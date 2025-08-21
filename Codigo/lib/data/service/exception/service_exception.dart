import 'dart:async';
import 'dart:io';

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
    final mensagem = exception.toString().toLowerCase();

    if (exception is SocketException ||
        mensagem.contains('SocketException') ||
        mensagem.contains('Failed host lookup')) {
      return TipoErro.offline;
    }
    if (exception is TimeoutException) {
      return TipoErro.timeout;
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
    if (mensagem.contains('not found')) {
      return TipoErro.notFound;
    }
    if (mensagem.contains('bad request')) {
      return TipoErro.badRequest;
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
    return TipoErro.unknown;
  }

  static String _mensagemParaTipoErro(TipoErro tipo) {
    switch (tipo) {
      case TipoErro.offline:
        return 'Sem conexão com a internet.';
      case TipoErro.timeout:
        return 'A requisição demorou demais.';
      case TipoErro.userBadLogin:
        return 'Usuário ou senha inválidos.';
      case TipoErro.userMissingInformation:
        return 'Faltam informações obrigatórias.';
      case TipoErro.userTooManyRequests:
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case TipoErro.invalidRefreshToken:
        return 'Token de atualização inválido.';
      case TipoErro.expiredRefreshToken:
        return 'Token expirado.';
      case TipoErro.noSessionFound:
        return 'Nenhuma sessão encontrada.';
      case TipoErro.permissionDenied:
        return 'Permissão negada.';
      case TipoErro.duplicateKey:
        return 'Registro duplicado.';
      case TipoErro.notFound:
        return 'Recurso não encontrado.';
      case TipoErro.badRequest:
        return 'Requisição inválida.';
      case TipoErro.databaseError:
        return 'Ocorreu um erro ao acessar o banco de dados.';
      case TipoErro.serverError:
        return 'Erro no servidor.';
      case TipoErro.syntaxError:
        return 'Erro de sintaxe no comando SQL.';
      case TipoErro.relationNotFound:
        return 'Tabela ou relação não encontrada no banco de dados.';
      case TipoErro.columnNotFound:
        return 'Coluna não encontrada no banco de dados.';
      case TipoErro.primaryKeyViolation:
        return 'Registro duplicado.';
      case TipoErro.foreignKeyViolation:
        return 'Violação de chave estrangeira.';
      case TipoErro.notNullViolation:
        return 'Campo obrigatório não preenchido.';
      case TipoErro.uniqueViolation:
        return 'Valor duplicado.';
      case TipoErro.connectionFailed:
        return 'Falha na conexão com o banco de dados.';
      case TipoErro.unknown:
        return 'Erro desconhecido';
    }
  }
}
