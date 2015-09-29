{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- set check_mail_stack = salt['pillar.get']('mail:check_mail_stack', {}) %}

include:
  - amavis
  - amavis.nrpe
  - amavis.diamond
  - amavis.clamav
  - clamav.server
  - clamav.server.apparmor
  - clamav.server.nrpe
  - clamav.server.diamond
  - doc
  - dovecot
  - dovecot.backup
  - dovecot.backup.diamond
  - dovecot.backup.nrpe
  - dovecot.diamond
  - dovecot.fail2ban
  - dovecot.fail2ban.diamond
  - dovecot.nrpe
  - mail.server.nrpe
  - mail.server.diamond
  - openldap
  - openldap.diamond
  - openldap.nrpe
  - postfix.nrpe
  - postfix.diamond
  - postfix.fail2ban

{%- call test_cron() %}
- sls: amavis
- sls: amavis.nrpe
- sls: amavis.diamond
{# - sls: amavis.clamav this formula only extend this requirement fail #}
- sls: clamav.server.nrpe
- sls: clamav.server.diamond
- sls: dovecot
- sls: dovecot.backup
- sls: dovecot.backup.nrpe
- sls: dovecot.diamond
- sls: dovecot.fail2ban
- sls: dovecot.fail2ban.diamond
- sls: dovecot.nrpe
- sls: mail.server.nrpe
- sls: openldap
- sls: openldap.diamond
- sls: openldap.nrpe
- sls: postfix.nrpe
- sls: postfix.diamond
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        Amavis:
          {#-
          amavis.CacheAttempts.count: False
          amavis.CacheAttempts.percentage: False
          amavis.CacheAttempts.frequency: False
          amavis.CacheMisses.count: False
          amavis.CacheMisses.percentage: False
          amavis.CacheMisses.frequency: False
          #}
          amavis.ContentCleanMsgs.count: False
          amavis.ContentCleanMsgs.percentage: False
          amavis.ContentCleanMsgs.frequency: True
          amavis.ContentCleanMsgsInternal.count: False
          amavis.ContentCleanMsgsInternal.percentage: False
          amavis.ContentCleanMsgsInternal.frequency: True
          amavis.ContentCleanMsgsOriginating.count: False
          amavis.ContentCleanMsgsOriginating.percentage: False
          amavis.ContentCleanMsgsOriginating.frequency: True
          amavis.ContentSpamMsgs.count: False
          amavis.ContentSpamMsgs.percentage: False
          amavis.ContentSpamMsgs.frequency: True
          amavis.ContentSpamMsgsInternal.count: False
          amavis.ContentSpamMsgsInternal.percentage: False
          amavis.ContentSpamMsgsInternal.frequency: True
          amavis.ContentSpamMsgsOriginating.count: False
          amavis.ContentSpamMsgsOriginating.percentage: False
          amavis.ContentSpamMsgsOriginating.frequency: True
          amavis.InMsgs.count: False
          amavis.InMsgs.percentage: False
          amavis.InMsgs.frequency: False
          amavis.InMsgsInternal.count: False
          amavis.InMsgsInternal.percentage: False
          amavis.InMsgsInternal.frequency: False
          amavis.InMsgsOriginating.count: False
          amavis.InMsgsOriginating.percentage: False
          amavis.InMsgsOriginating.frequency: False
          amavis.InMsgsRecips.count: False
          amavis.InMsgsRecips.percentage: False
          amavis.InMsgsRecips.frequency: False
          amavis.InMsgsRecipsInternal.count: False
          amavis.InMsgsRecipsInternal.percentage: False
          amavis.InMsgsRecipsInternal.frequency: False
          amavis.InMsgsRecipsLocal.count: False
          amavis.InMsgsRecipsLocal.percentage: False
          amavis.InMsgsRecipsLocal.frequency: False
          amavis.InMsgsRecipsOriginating.count: False
          amavis.InMsgsRecipsOriginating.percentage: False
          amavis.InMsgsRecipsOriginating.frequency: False
          amavis.InMsgsSize.percentage: False
          amavis.InMsgsSize.frequency: True
          amavis.InMsgsSize.size: True
          amavis.InMsgsSizeInternal.percentage: False
          amavis.InMsgsSizeInternal.frequency: True
          amavis.InMsgsSizeInternal.size: True
          amavis.InMsgsSizeOriginating.percentage: False
          amavis.InMsgsSizeOriginating.frequency: True
          amavis.InMsgsSizeOriginating.size: True
          amavis.InMsgsStatusRelayed.count: False
          amavis.InMsgsStatusRelayed.percentage: False
          amavis.InMsgsStatusRelayed.frequency: False
          amavis.LogEntries.count: False
          amavis.LogEntries.percentage: False
          amavis.LogEntries.frequency: False
          amavis.LogEntriesDebug.count: False
          amavis.LogEntriesDebug.percentage: False
          amavis.LogEntriesDebug.frequency: False
          amavis.LogEntriesInfo.count: False
          amavis.LogEntriesInfo.percentage: False
          amavis.LogEntriesInfo.frequency: False
          amavis.LogEntriesLevel0.count: False
          amavis.LogEntriesLevel0.percentage: False
          amavis.LogEntriesLevel0.frequency: False
          amavis.LogEntriesNotice.count: False
          amavis.LogEntriesNotice.percentage: False
          amavis.LogEntriesNotice.frequency: False
          amavis.LogLines.count: False
          amavis.LogLines.percentage: False
          amavis.LogLines.frequency: False
{#- This metric didn't collected during CI test, it needs to wait until
    Amavisd-agent function properly. Skip check this.
          amavis.LogRetries.count: False
          amavis.LogRetries.percentage: False
          amavis.LogRetries.frequency: False #}
          amavis.OpsDec.count: False
          amavis.OpsDec.percentage: False
          amavis.OpsDec.frequency: False
          amavis.OpsDecByMimeParser.count: False
          amavis.OpsDecByMimeParser.percentage: False
          amavis.OpsDecByMimeParser.frequency: False
          amavis.OpsSpamCheck.count: False
          amavis.OpsSpamCheck.percentage: False
          amavis.OpsSpamCheck.frequency: False
          amavis.OutConnNew.count: False
          amavis.OutConnNew.percentage: False
          amavis.OutConnNew.frequency: False
          amavis.OutConnTransact.count: False
          amavis.OutConnTransact.percentage: False
          amavis.OutConnTransact.frequency: False
          amavis.OutMsgs.count: False
          amavis.OutMsgs.percentage: False
          amavis.OutMsgs.frequency: False
          amavis.OutMsgsDelivers.count: False
          amavis.OutMsgsDelivers.percentage: False
          amavis.OutMsgsDelivers.frequency: False
          amavis.OutMsgsProtoLocal.count: False
          amavis.OutMsgsProtoLocal.percentage: False
          amavis.OutMsgsProtoLocal.frequency: True
          amavis.OutMsgsProtoLocalSubmit.count: False
          amavis.OutMsgsProtoLocalSubmit.percentage: False
          amavis.OutMsgsProtoLocalSubmit.frequency: True
          amavis.OutMsgsProtoSMTP.count: False
          amavis.OutMsgsProtoSMTP.percentage: False
          amavis.OutMsgsProtoSMTP.frequency: False
          amavis.OutMsgsProtoSMTPRelay.count: False
          amavis.OutMsgsProtoSMTPRelay.percentage: False
          amavis.OutMsgsProtoSMTPRelay.frequency: False
          amavis.OutMsgsRelay.count: False
          amavis.OutMsgsRelay.percentage: False
          amavis.OutMsgsRelay.frequency: False
          amavis.OutMsgsSize.percentage: False
          amavis.OutMsgsSize.frequency: True
          amavis.OutMsgsSize.size: True
          amavis.OutMsgsSizeProtoLocal.percentage: False
          amavis.OutMsgsSizeProtoLocal.frequency: True
          amavis.OutMsgsSizeProtoLocal.size: True
          amavis.OutMsgsSizeProtoLocalSubmit.percentage: False
          amavis.OutMsgsSizeProtoLocalSubmit.frequency: True
          amavis.OutMsgsSizeProtoLocalSubmit.size: True
          amavis.OutMsgsSizeProtoSMTP.percentage: False
          amavis.OutMsgsSizeProtoSMTP.frequency: True
          amavis.OutMsgsSizeProtoSMTP.size: True
          amavis.OutMsgsSizeProtoSMTPRelay.percentage: False
          amavis.OutMsgsSizeProtoSMTPRelay.frequency: True
          amavis.OutMsgsSizeProtoSMTPRelay.size: True
          amavis.OutMsgsSizeRelay.percentage: False
          amavis.OutMsgsSizeRelay.frequency: True
          amavis.OutMsgsSizeRelay.size: True
          amavis.OutMsgsSizeSubmit.percentage: False
          amavis.OutMsgsSizeSubmit.frequency: True
          amavis.OutMsgsSizeSubmit.size: True
          amavis.OutMsgsSizeSubmitQuar.percentage: False
          amavis.OutMsgsSizeSubmitQuar.frequency: True
          amavis.OutMsgsSizeSubmitQuar.size: True
          amavis.OutMsgsSubmit.count: False
          amavis.OutMsgsSubmit.percentage: False
          amavis.OutMsgsSubmit.frequency: True
          amavis.OutMsgsSubmitQuar.count: False
          amavis.OutMsgsSubmitQuar.percentage: False
          amavis.OutMsgsSubmitQuar.frequency: True
          amavis.QuarMsgs.count: False
          amavis.QuarMsgs.percentage: False
          amavis.QuarMsgs.frequency: True
          amavis.QuarMsgsSize.percentage: False
          amavis.QuarMsgsSize.frequency: True
          amavis.QuarMsgsSize.size: True
          amavis.QuarMsgsSizeSpam.percentage: False
          amavis.QuarMsgsSizeSpam.frequency: True
          amavis.QuarMsgsSizeSpam.size: True
          amavis.QuarMsgsSpam.count: False
          amavis.QuarMsgsSpam.percentage: False
          amavis.QuarMsgsSpam.frequency: True
          amavis.TimeElapsedDecoding.frequency: True
          amavis.TimeElapsedDecoding.time: True
          amavis.TimeElapsedReceiving.frequency: True
          amavis.TimeElapsedReceiving.time: True
          amavis.TimeElapsedSending.frequency: True
          amavis.TimeElapsedSending.time: True
          amavis.TimeElapsedSpamCheck.frequency: True
          amavis.TimeElapsedSpamCheck.time: False
          amavis.TimeElapsedTotal.frequency: True
          amavis.TimeElapsedTotal.time: False
          amavis.OpsDecType-asc.count: False
          amavis.OpsDecType-asc.percentage: False
          amavis.OpsDecType-asc.frequency: False
        Postfix:
          postfix.(recv|send).status.sent: True
        ProcessResources:
          {{ diamond_process_test('amavis') }}
          {{ diamond_process_test('postfix') }}
        Mail:
          mail.total: True
        UserScripts:
          postfix.queue_length: True
    - require:
      - sls: amavis
      - sls: amavis.diamond
      - sls: postfix
      - sls: postfix.diamond
      - monitoring: test
  qa:
{%- if check_mail_stack is mapping and check_mail_stack|length > 0 %}
    - test
    - doc: {{ opts['cachedir'] }}/doc/output
{%- else %}
    - test_pillar
    - doc: {{ opts['cachedir'] }}/doc/output
{%- endif %}
    - name: mail.server
    - require:
      - monitoring: test
      - cmd: doc
