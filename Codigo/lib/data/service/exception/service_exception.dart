import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:merchandising_app/ui/core/logger/app_logger.dart';

enum TipoErro {
  databaseError,
  syntaxError,
  relationNotFound,
  columnNotFound,
  primaryKeyViolation,
  foreignKeyViolation,
  unknown,
  offline,
  timeout,
  serverError,
  notNullViolation,
  uniqueViolation,
  connectionFailed,
  userBadLogin,
  userMissingInformation,
  userTooManyRequests,
  invalidRefreshToken,
  expiredRefreshToken,
  noSessionFound,
  permissionDenied,
  duplicateKey,
  notFound,
  badRequest,
}

class ServiceException implements Exception {
  final String mensagem;
  final TipoErro tipo;
  ServiceException._(this.mensagem, this.tipo);

  factory ServiceException(dynamic exception) {
    final TipoErro tipo = _detectarTipoErro(exception);
    final String mensagemErro = _mensagemParaTipoErro(tipo);
    return ServiceException._(mensagemErro, tipo);
  }

  @override
  String toString() => mensagem;

  static TipoErro _detectarTipoErro(dynamic exception) {
    final String mensagem = exception.toString().toLowerCase();
    AppLogger.instance.e("Error: ${exception.runtimeType}");
    if (exception is TimeoutException) {
      return TipoErro.timeout;
    }

    if (exception is SocketException ||
        exception is http.ClientException ||
        mensagem.contains('socketexception') ||
        mensagem.contains('failed host lookup')) {
      return TipoErro.offline;
    }
    if (mensagem.contains('500')) {
      return TipoErro.serverError;
    }
    if (mensagem.contains('invalid login')) {
      return TipoErro.userBadLogin;
    }
    if (mensagem.contains('missing information')) {
      return TipoErro.userMissingInformation;
    }
    if (mensagem.contains('too many requests')) {
      return TipoErro.userTooManyRequests;
    }
    if (mensagem.contains('refresh token invalid')) {
      return TipoErro.invalidRefreshToken;
    }
    if (mensagem.contains('refresh token expired')) {
      return TipoErro.expiredRefreshToken;
    }
    if (mensagem.contains('no session')) {
      return TipoErro.noSessionFound;
    }
    if (mensagem.contains('permission denied')) {
      return TipoErro.permissionDenied;
    }
    if (mensagem.contains('duplicate key')) {
      return TipoErro.duplicateKey;
    }
    if (mensagem.contains('syntax error')) {
      return TipoErro.syntaxError;
    }
    if (mensagem.contains('relation') && mensagem.contains('does not exist')) {
      return TipoErro.relationNotFound;
    }
    if (mensagem.contains('column') && mensagem.contains('does not exist')) {
      return TipoErro.columnNotFound;
    }
    if (mensagem.contains('violates unique constraint') &&
        mensagem.contains('pkey')) {
      return TipoErro.primaryKeyViolation;
    }
    if (mensagem.contains('violates foreign key constraint')) {
      return TipoErro.foreignKeyViolation;
    }
    if (mensagem.contains('violates not-null constraint')) {
      return TipoErro.notNullViolation;
    }
    if (mensagem.contains('violates unique constraint') &&
        !mensagem.contains('pkey')) {
      return TipoErro.uniqueViolation;
    }
    if (mensagem.contains('could not connect to server') ||
        mensagem.contains('connection refused')) {
      return TipoErro.connectionFailed;
    }
    if (mensagem.contains('postgres') ||
        mensagem.contains('database') ||
        mensagem.contains('sql error')) {
      return TipoErro.databaseError;
    }
    if (mensagem.contains('not found')) {
      return TipoErro.notFound;
    }
    if (mensagem.contains('bad request')) {
      return TipoErro.badRequest;
    }
    return TipoErro.unknown;
  }

  static String _mensagemParaTipoErro(TipoErro tipo) {
    switch (tipo) {
      case TipoErro.offline:
        return 'Sem conexão com a internet.';
      case TipoErro.timeout:
        return 'A requisição demorou demais. Tente novamente mais tarde.';
      case TipoErro.userBadLogin:
        return 'Usuário ou senha inválidos.';
      case TipoErro.userMissingInformation:
        return 'Faltam informações obrigatórias.';
      case TipoErro.userTooManyRequests:
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case TipoErro.invalidRefreshToken:
        return 'Token de atualização inválido. Faça login novamente.';
      case TipoErro.expiredRefreshToken:
        return 'Token expirado.';
      case TipoErro.noSessionFound:
        return 'Nenhuma sessão encontrada.';
      case TipoErro.permissionDenied:
        return 'Permissão negada. Contate o suporte.';
      case TipoErro.duplicateKey:
        return 'Registro duplicado.';
      case TipoErro.notFound:
        return 'Recurso não encontrado. Contate o suporte.';
      case TipoErro.badRequest:
        return 'Requisição inválida. Contate o suporte.';
      case TipoErro.databaseError:
        return 'Ocorreu um erro ao acessar o banco de dados. Contate o suporte.';
      case TipoErro.serverError:
        return 'Erro no servidor.';
      case TipoErro.syntaxError:
        return 'Erro de sintaxe no comando SQL. Contate o suporte.';
      case TipoErro.relationNotFound:
        return 'Tabela ou relação não encontrada no banco de dados. Contate o suporte.';
      case TipoErro.columnNotFound:
        return 'Coluna não encontrada no banco de dados. Contate o suporte.';
      case TipoErro.primaryKeyViolation:
        return 'Violação de chave primária. Contate o suporte.';
      case TipoErro.foreignKeyViolation:
        return 'Violação de chave estrangeira.';
      case TipoErro.notNullViolation:
        return 'Campo obrigatório não preenchido. Contate o suporte.';
      case TipoErro.uniqueViolation:
        return 'Valor duplicado.';
      case TipoErro.connectionFailed:
        return 'Falha na conexão com o banco de dados. Contate o suporte.';
      case TipoErro.unknown:
        return 'Erro desconhecido. Contate o suporte.';
    }
  }
}
