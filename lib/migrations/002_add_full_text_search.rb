Sequel.migration do
  up do
    add_column :plants, :tsv, 'TSVector'

    add_index :plants, :latin_name
    add_index :plants, :common_name

    run %{
      CREATE INDEX tsv_GIN ON plants \
        USING GIN(tsv);
    }

    run %{
      CREATE TRIGGER TS_tsv \
        BEFORE INSERT OR UPDATE ON plants \
      FOR EACH ROW EXECUTE PROCEDURE \
        tsvector_update_trigger(tsv, 'pg_catalog.english', latin_name, common_name, description);
    }
  end

  down do
    drop_column :plants, :tsv
    drop_index :plants, :latin_name
    drop_index :plants, :common_name
    drop_index :plants, :tsv_GIN
    drop_trigger :plants, :TS_tsv
  end
end