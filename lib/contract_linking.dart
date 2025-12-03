import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://10.167.24.228:7545";
  final String _privateKey =
      "0x14012b3a426efb4710acd157555f38fb9ab50aac61d3b1f92fa62ca48fd62b77";

  late Web3Client _client;

  bool isLoading = true;

  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _getNameFunction;
  late ContractFunction _setNameFunction;

  String deployedName = "Loading...";

  ContractLinking() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    _client = Web3Client(_rpcUrl, Client());

    await _loadAbiAndAddress();
    await _loadCredentials();
    await _loadDeployedContract();

    await getName();
  }

  Future<void> _loadAbiAndAddress() async {
    String abiString = await rootBundle.loadString(
      "src/artifacts/HelloWorld.json",
    );
    final jsonAbi = jsonDecode(abiString);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    // ⚠️ Important : utilise la nouvelle adresse déployée
    _contractAddress = EthereumAddress.fromHex(
      jsonAbi["networks"]["5777"]["address"],
    );
  }

  Future<void> _loadCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> _loadDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );

    _getNameFunction = _contract.function("getName");
    _setNameFunction = _contract.function("setName");
  }

  Future<void> getName() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _client.call(
        contract: _contract,
        function: _getNameFunction,
        params: [],
      );

      // ⚡ Web3dart renvoie un List<dynamic>, pour string c'est [0]
      deployedName = result[0].toString();
    } catch (e) {
      print("getName error: $e");
      deployedName = "Erreur";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();

    try {
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setNameFunction,
          parameters: [nameToSet],
          maxGas: 100000,
        ),
        chainId: 1337,
      );

      // Recharge le nom après la transaction
      await getName();
    } catch (e) {
      print("setName error: $e");
      deployedName = "Erreur transaction";
      isLoading = false;
      notifyListeners();
    }
  }
}
