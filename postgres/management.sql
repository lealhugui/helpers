-- List all active processes (it shows the current connection client process too)
select * from pg_stat_activity where state = 'active';

-- Detect blocked queries
select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;

-- Cancel (gracefull terminate) query
select pg_cancel_backend(:pg_process_pid)

-- Terminate query
select pg_terminate_backend(:pg_process_pid)