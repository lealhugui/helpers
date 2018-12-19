DECLARE
  c_value    VARCHAR(2000) := 'SPENGLER';
  c_owner    VARCHAR(200)  := 'COMMERCE';
  v_count    NUMBER(20)    := 0;
  v_sql_stmt VARCHAR(32762);
BEGIN
  FOR r IN (SELECT a.*
            FROM all_tab_columns a
            WHERE owner IN (c_owner)
              AND a.data_type = 'VARCHAR2'
              AND a.table_name NOT LIKE '%BIN$%'
              AND NOT EXISTS(SELECT * FROM ALL_EXTERNAL_TABLES ex where ex.table_name = a.table_name)
            ORDER BY table_name)
    LOOP

      v_count := 0;
      v_sql_stmt := 'select count(1) from ' || r.table_name ||
                    ' where ' || r.column_name || ' like ''%'' || :1  || ''%''';

      BEGIN
        EXECUTE IMMEDIATE v_sql_stmt INTO v_count USING c_value;
        EXCEPTION
        WHEN OTHERS
        THEN
          raise_application_error(-20001, v_sql_stmt);
      END;

      IF (v_count > 0)
      THEN
        dbms_output.put_line(
            r.table_name || '.' || r.column_name || '=' || c_value
          );
      END IF;

    END LOOP;
END;