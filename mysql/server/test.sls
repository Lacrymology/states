{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'fail2ban/macro.jinja2' import fail2ban_regex_test with context %}
include:
  - doc
  - mysql.server
  - mysql.server.backup
  - mysql.server.diamond
  - mysql.server.fail2ban
  - mysql.server.fail2ban.diamond
  - mysql.server.nrpe

{{ fail2ban_regex_test('mysql', tag='mysqld', message="150114  3:40:50 [Warning] Access denied for user 'root'@'5.6.7.8' (using password: YES)") }}

test:
  cmd:
    - run
    - name: /usr/local/bin/backup-mysql-all
    - require:
      - file: /usr/local/bin/backup-mysql-all
  diamond:
    - test
    - map:
        MySQL:
          {#-
          Most of metrics values are zero because it's the derivative
          (http://en.wikipedia.org/wiki/Derivative) of the actual value.

          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/collectors/mysql/mysql.py#L420
          https://github.com/BrightcoveOS/Diamond/blob/v3.5/src/diamond/collector.py#L438
          #}
          mysql.Aborted_clients: True
          mysql.Aborted_connects: True
          mysql.Binlog_cache_disk_use: True
          mysql.Binlog_cache_use: True
          mysql.Bytes_received: True
          mysql.Bytes_sent: True
          mysql.Com_admin_commands: True
          mysql.Com_alter_db: True
          mysql.Com_alter_db_upgrade: True
          mysql.Com_alter_event: True
          mysql.Com_alter_function: True
          mysql.Com_alter_procedure: True
          mysql.Com_alter_server: True
          mysql.Com_alter_table: True
          mysql.Com_alter_tablespace: True
          mysql.Com_analyze: True
          mysql.Com_assign_to_keycache: True
          mysql.Com_begin: True
          mysql.Com_binlog: True
          mysql.Com_call_procedure: True
          mysql.Com_change_db: True
          mysql.Com_change_master: True
          mysql.Com_check: True
          mysql.Com_checksum: True
          mysql.Com_commit: True
          mysql.Com_create_db: True
          mysql.Com_create_event: True
          mysql.Com_create_function: True
          mysql.Com_create_index: True
          mysql.Com_create_procedure: True
          mysql.Com_create_server: True
          mysql.Com_create_table: True
          mysql.Com_create_trigger: True
          mysql.Com_create_udf: True
          mysql.Com_create_user: True
          mysql.Com_create_view: True
          mysql.Com_dealloc_sql: True
          mysql.Com_delete: True
          mysql.Com_delete_multi: True
          mysql.Com_do: True
          mysql.Com_drop_db: True
          mysql.Com_drop_event: True
          mysql.Com_drop_function: True
          mysql.Com_drop_index: True
          mysql.Com_drop_procedure: True
          mysql.Com_drop_server: True
          mysql.Com_drop_table: True
          mysql.Com_drop_trigger: True
          mysql.Com_drop_user: True
          mysql.Com_drop_view: True
          mysql.Com_empty_query: True
          mysql.Com_execute_sql: True
          mysql.Com_flush: True
          mysql.Com_grant: True
          mysql.Com_ha_close: True
          mysql.Com_ha_open: True
          mysql.Com_ha_read: True
          mysql.Com_help: True
          mysql.Com_insert: True
          mysql.Com_insert_select: True
          mysql.Com_install_plugin: True
          mysql.Com_kill: True
          mysql.Com_load: True
          mysql.Com_lock_tables: True
          mysql.Com_optimize: True
          mysql.Com_preload_keys: True
          mysql.Com_prepare_sql: True
          mysql.Com_purge: True
          mysql.Com_purge_before_date: True
          mysql.Com_release_savepoint: True
          mysql.Com_rename_table: True
          mysql.Com_rename_user: True
          mysql.Com_repair: True
          mysql.Com_replace: True
          mysql.Com_replace_select: True
          mysql.Com_reset: True
          mysql.Com_revoke: True
          mysql.Com_revoke_all: True
          mysql.Com_rollback: True
          mysql.Com_rollback_to_savepoint: True
          mysql.Com_savepoint: True
          mysql.Com_select: True
          mysql.Com_set_option: True
          mysql.Com_show_authors: True
          mysql.Com_show_binlog_events: True
          mysql.Com_show_binlogs: True
          mysql.Com_show_charsets: True
          mysql.Com_show_collations: True
          mysql.Com_show_contributors: True
          mysql.Com_show_create_db: True
          mysql.Com_show_create_event: True
          mysql.Com_show_create_func: True
          mysql.Com_show_create_proc: True
          mysql.Com_show_create_table: True
          mysql.Com_show_create_trigger: True
          mysql.Com_show_databases: True
          mysql.Com_show_engine_logs: True
          mysql.Com_show_engine_mutex: True
          mysql.Com_show_engine_status: True
          mysql.Com_show_errors: True
          mysql.Com_show_events: True
          mysql.Com_show_fields: True
          mysql.Com_show_function_status: True
          mysql.Com_show_grants: True
          mysql.Com_show_keys: True
          mysql.Com_show_master_status: True
          mysql.Com_show_open_tables: True
          mysql.Com_show_plugins: True
          mysql.Com_show_privileges: True
          mysql.Com_show_procedure_status: True
          mysql.Com_show_processlist: True
          mysql.Com_show_profile: True
          mysql.Com_show_profiles: True
          mysql.Com_show_slave_hosts: True
          mysql.Com_show_slave_status: True
          mysql.Com_show_status: True
          mysql.Com_show_storage_engines: True
          mysql.Com_show_table_status: True
          mysql.Com_show_tables: True
          mysql.Com_show_triggers: True
          mysql.Com_show_variables: True
          mysql.Com_show_warnings: True
          mysql.Com_slave_start: True
          mysql.Com_slave_stop: True
          mysql.Com_stmt_close: True
          mysql.Com_stmt_execute: True
          mysql.Com_stmt_fetch: True
          mysql.Com_stmt_prepare: True
          mysql.Com_stmt_reprepare: True
          mysql.Com_stmt_reset: True
          mysql.Com_stmt_send_long_data: True
          mysql.Com_truncate: True
          mysql.Com_uninstall_plugin: True
          mysql.Com_unlock_tables: True
          mysql.Com_update: True
          mysql.Com_update_multi: True
          mysql.Com_xa_commit: True
          mysql.Com_xa_end: True
          mysql.Com_xa_prepare: True
          mysql.Com_xa_recover: True
          mysql.Com_xa_rollback: True
          mysql.Com_xa_start: True
          mysql.Connections: True
          mysql.Created_tmp_disk_tables: True
          mysql.Created_tmp_files: True
          mysql.Created_tmp_tables: True
          mysql.Delayed_errors: True
          mysql.Delayed_insert_threads: True
          mysql.Delayed_writes: True
          mysql.Flush_commands: True
          mysql.Handler_commit: True
          mysql.Handler_delete: True
          mysql.Handler_discover: True
          mysql.Handler_prepare: True
          mysql.Handler_read_first: True
          mysql.Handler_read_key: True
          mysql.Handler_read_next: True
          mysql.Handler_read_prev: True
          mysql.Handler_read_rnd: True
          mysql.Handler_read_rnd_next: True
          mysql.Handler_rollback: True
          mysql.Handler_savepoint: True
          mysql.Handler_savepoint_rollback: True
          mysql.Handler_update: True
          mysql.Handler_write: True
          mysql.Innodb_buffer_pool_pages_data: True
          mysql.Innodb_buffer_pool_pages_dirty: True
          mysql.Innodb_buffer_pool_pages_flushed: True
          mysql.Innodb_buffer_pool_pages_free: True
          mysql.Innodb_buffer_pool_pages_misc: True
          mysql.Innodb_buffer_pool_pages_total: True
          mysql.Innodb_buffer_pool_read_ahead_rnd: True
          mysql.Innodb_buffer_pool_read_requests: True
          mysql.Innodb_buffer_pool_reads: True
          mysql.Innodb_buffer_pool_wait_free: True
          mysql.Innodb_buffer_pool_write_requests: True
          mysql.Innodb_data_fsyncs: True
          mysql.Innodb_data_pending_fsyncs: True
          mysql.Innodb_data_pending_reads: True
          mysql.Innodb_data_pending_writes: True
          mysql.Innodb_data_read: True
          mysql.Innodb_data_reads: True
          mysql.Innodb_data_writes: True
          mysql.Innodb_data_written: True
          mysql.Innodb_dblwr_pages_written: True
          mysql.Innodb_dblwr_writes: True
          mysql.Innodb_log_waits: True
          mysql.Innodb_log_write_requests: True
          mysql.Innodb_log_writes: True
          mysql.Innodb_os_log_fsyncs: True
          mysql.Innodb_os_log_pending_fsyncs: True
          mysql.Innodb_os_log_pending_writes: True
          mysql.Innodb_os_log_written: True
          mysql.Innodb_page_size: True
          mysql.Innodb_pages_created: True
          mysql.Innodb_pages_read: True
          mysql.Innodb_pages_written: True
          mysql.Innodb_row_lock_current_waits: True
          mysql.Innodb_row_lock_time: True
          mysql.Innodb_row_lock_time_avg: True
          mysql.Innodb_row_lock_time_max: True
          mysql.Innodb_row_lock_waits: True
          mysql.Innodb_rows_deleted: True
          mysql.Innodb_rows_inserted: True
          mysql.Innodb_rows_read: True
          mysql.Innodb_rows_updated: True
          mysql.Key_blocks_not_flushed: True
          mysql.Key_blocks_unused: True
          mysql.Key_blocks_used: True
          mysql.Key_read_requests: True
          mysql.Key_reads: True
          mysql.Key_write_requests: True
          mysql.Key_writes: True
          mysql.Last_query_cost: True
          mysql.Max_used_connections: True
          mysql.Not_flushed_delayed_rows: True
          mysql.Open_files: True
          mysql.Open_streams: True
          mysql.Open_table_definitions: True
          mysql.Open_tables: True
          mysql.Opened_files: True
          mysql.Opened_table_definitions: True
          mysql.Opened_tables: True
          mysql.Prepared_stmt_count: True
          mysql.Qcache_free_blocks: True
          mysql.Qcache_free_memory: True
          mysql.Qcache_hits: True
          mysql.Qcache_inserts: True
          mysql.Qcache_lowmem_prunes: True
          mysql.Qcache_not_cached: True
          mysql.Qcache_queries_in_cache: True
          mysql.Qcache_total_blocks: True
          mysql.Queries: True
          mysql.Questions: True
          mysql.Select_full_join: True
          mysql.Select_full_range_join: True
          mysql.Select_range: True
          mysql.Select_range_check: True
          mysql.Select_scan: True
          mysql.Slave_open_temp_tables: True
          mysql.Slave_retried_transactions: True
          mysql.Slow_launch_threads: True
          mysql.Slow_queries: True
          mysql.Sort_merge_passes: True
          mysql.Sort_range: True
          mysql.Sort_rows: True
          mysql.Sort_scan: True
          mysql.Ssl_accept_renegotiates: True
          mysql.Ssl_accepts: True
          mysql.Ssl_callback_cache_hits: True
          mysql.Ssl_client_connects: True
          mysql.Ssl_connect_renegotiates: True
          mysql.Ssl_ctx_verify_depth: True
          mysql.Ssl_ctx_verify_mode: True
          mysql.Ssl_default_timeout: True
          mysql.Ssl_finished_accepts: True
          mysql.Ssl_finished_connects: True
          mysql.Ssl_session_cache_hits: True
          mysql.Ssl_session_cache_misses: True
          mysql.Ssl_session_cache_overflows: True
          mysql.Ssl_session_cache_size: True
          mysql.Ssl_session_cache_timeouts: True
          mysql.Ssl_sessions_reused: True
          mysql.Ssl_used_session_cache_entries: True
          mysql.Ssl_verify_depth: True
          mysql.Ssl_verify_mode: True
          mysql.Table_locks_immediate: True
          mysql.Table_locks_waited: True
          mysql.Tc_log_max_pages_used: True
          mysql.Tc_log_page_size: True
          mysql.Tc_log_page_waits: True
          mysql.Threads_cached: True
          mysql.Threads_connected: True
          mysql.Threads_created: True
          mysql.Threads_running: False
          mysql.Uptime: True
          mysql.Uptime_since_flush_status: True
        ProcessResources:
          {{ diamond_process_test('mysql') }}
        UserScripts:
          fail2ban.mysqld: True
    - require:
      - sls: mysql.server
      - sls: mysql.server.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: mysql.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
