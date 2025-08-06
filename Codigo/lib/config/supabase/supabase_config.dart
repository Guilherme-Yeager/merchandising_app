import 'package:merchandising_app/ui/core/logger/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseConfig {
  /// Indica se já existe inscrição ativa em canais de realtime.
  static bool isInscribeChannels = false;

  /// Inicializa o Supabase com as variáveis de ambiente `URL` e `ANONKEY`.
  ///
  /// Registra logs de sucesso ou aviso caso as chaves não estejam definidas.
  static Future<void> initialize() async {
    const String url = String.fromEnvironment('URL');
    const String anonKey = String.fromEnvironment('ANONKEY');
    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(url: url, anonKey: anonKey);
      AppLogger.instance.i("Supabase inicializado com sucesso.");
    } else {
      AppLogger.instance.w("Chaves do supabase não encontradas.");
    }
  }

  /// Inscreve o cliente para receber notificações em tempo real
  /// sobre qualquer alteração (inserção, atualização, deleção) na tabela `pcclient`.
  ///
  /// [callback] é chamado sempre que uma alteração é detectada,
  /// e recebe como parâmetro o código do usuário ([codusur]) para o [callback].
  static void inscribeRealTimeChangeCliente(Function callback, int codusur) {
    Supabase.instance.client
        .channel('clients-realtime-changes')
        .onPostgresChanges(
          schema: 'public',
          table: 'pcclient',
          event: PostgresChangeEvent.all,
          callback: (payload) {
            AppLogger.instance.w(
              "Alteração detectada em 'pcclient': [tipo - ${payload.eventType}] | [codcli - ${payload.newRecord['codcli']}] | [codusur - ${payload.newRecord['codusur']}]",
            );

            /// Caso a alteração seja de um cliente associado ao usuário,
            /// chama o callback para atualizar a lista de clientes.
            if (payload.newRecord['codusur'] == codusur) {
              callback(codusur);
            }
          },
        )
        .subscribe();
    AppLogger.instance.i(
      "Inscrito em alterações de tempo real na tabela 'pcclient'.",
    );
    isInscribeChannels = true;
  }

  /// Inscreve o cliente para receber notificações em tempo real
  /// sobre qualquer alteração (inserção, atualização, deleção) na tabela `pcprodut`.
  ///
  /// [callback] é chamado sempre que uma alteração é detectada.
  static void inscribeRealTimeChangeProduto(Function callback) {
    Supabase.instance.client
        .channel('clients-realtime-changes')
        .onPostgresChanges(
          schema: 'public',
          table: 'pcprodut',
          event: PostgresChangeEvent.all,
          callback: (payload) {
            AppLogger.instance.w(
              "Alteração detectada em 'pcprodut': [tipo - ${payload.eventType}] | [codprod - ${payload.newRecord['codprod']}]",
            );
            callback();
          },
        )
        .subscribe();
    AppLogger.instance.i(
      "Inscrito em alterações de tempo real na tabela 'pcclient'.",
    );
    isInscribeChannels = true;
  }

  /// Remove todas as inscrições ativas em canais de realtime do Supabase.
  ///
  /// Caso não haja inscrições ativas, apenas loga um aviso.
  static void unsubscribeRealTimeChanges() {
    if (!isInscribeChannels) {
      AppLogger.instance.w(
        "Nenhuma inscrição ativa para alterações de tempo real.",
      );
      return;
    }
    Supabase.instance.client.removeAllChannels();
    isInscribeChannels = false;
    AppLogger.instance.i("Todas as inscrições de tempo real foram removidas.");
  }
}
