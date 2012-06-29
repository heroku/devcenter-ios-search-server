Sequel.migration do
  up do
    create_table :plants do
      primary_key :id
      
      varchar :latin_name,  empty: false
      varchar :common_name, empty: false
      varchar :description
    end
  end
  
  down do
    drop_table :plants
  end
end