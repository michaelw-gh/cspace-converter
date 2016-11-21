# PastPerfect

```
NOTE When exporting data to Excel, each field is limited to 254 characters. In most cases this won’t be a problem, except for data in unlimited memo fields like Description and Notes. If you want to export data that is longer than 254 characters, please choose the Excel/HTML option. This export creates an HTML (.htm) file that is opened in Excel. To save this file as an Excel file (.xls), please use the Save As option in Excel.
```

For earlier versions of Past Perfect (< 5) you may need to manually clean up long fields (> 254 characters) to avoid export truncation.

Process:

```
./bin/rake db:nuke

./import.sh pp_accession1 PastPerfect accessions PPSdata_accession
./import.sh pp_archives1 PastPerfect archives PPSdata_archives
./import.sh pp_library1 PastPerfect library PPSdata_library
./import.sh pp_objects1 PastPerfect objects PPSdata_objects
./import.sh pp_photos1 PastPerfect photos PPSdata_photos

# procedures
./bin/rake remote:action:transfer[Acquisition,all]
./bin/rake remote:action:transfer[CollectionObject,all]
./bin/rake remote:action:transfer[Media,all]
./bin/rake remote:action:transfer[Movement,all]
./bin/rake remote:action:transfer[ValuationControl,all]

# authorities
./bin/rake remote:action:transfer[Concept,all]
./bin/rake remote:action:transfer[Location,all]
./bin/rake remote:action:transfer[Organization,all]
./bin/rake remote:action:transfer[Person,all]
./bin/rake remote:action:transfer[Place,all]

# after other transfers
./bin/rake relationships:generate[pp_accession1]
./bin/rake relationships:generate[pp_archives1]
./bin/rake relationships:generate[pp_library1]
./bin/rake relationships:generate[pp_objects1]
./bin/rake relationships:generate[pp_photos1]

./bin/rake remote:action:transfer[Relationship,all]
```

To undo:

```
./bin/rake remote:action:delete[Acquisition,all]
./bin/rake remote:action:delete[CollectionObject,all]
./bin/rake remote:action:delete[Media,all]
./bin/rake remote:action:delete[Movement,all]
./bin/rake remote:action:delete[ValuationControl,all]

./bin/rake remote:action:delete[Concept,all]
./bin/rake remote:action:delete[Location,all]
./bin/rake remote:action:delete[Organization,all]
./bin/rake remote:action:delete[Person,all]
./bin/rake remote:action:delete[Place,all]

./bin/rake remote:action:delete[Relationship,all]
```

---