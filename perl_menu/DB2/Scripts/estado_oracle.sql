set pagesize 0
 set linesize 200

select instance_name, status, version, startup_time, active_state, instance_role  from v$instance; 

 quit;
