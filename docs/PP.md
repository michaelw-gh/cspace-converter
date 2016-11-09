# PastPerfect

If you want to import data from Past Perfect to CollectionSpace and you are using version 3 or lower you must export to the dbf format. You can use either of the FoxPro or dBase options. Then, after installing the requirements for `cspace-converter`, you can use the `dbf` cli tool to convert dbf to csv. For example:

```
dbf -c PPSdata_accession.dbf > PPSdata_accession.csv
```

If you are using a more recent or the current version of Past Perfect then you also have the option of exporting to Excel before saving as csv. However:

```
NOTE When exporting data to Excel, each field is limited to 254 characters. In most cases this won’t be a problem, except for data in unlimited memo fields like Description and Notes. If you want to export data that is longer than 254 characters, please choose the Excel/HTML option. This export creates an HTML (.htm) file that is opened in Excel. To save this file as an Excel file (.xls), please use the Save As option in Excel.
```

In either case you can use the `dbf` cli tool to produce the csv from dbf if you have a Ruby environment available to use.

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
./bin/rake remote:action:transfer[Location,all]
./bin/rake remote:action:transfer[Person,all]

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
./bin/rake remote:action:delete[Acquisition,pp_accession1]
./bin/rake remote:action:delete[CollectionObject,pp_archives1]
./bin/rake remote:action:delete[CollectionObject,pp_library1]
./bin/rake remote:action:delete[CollectionObject,pp_objects1]
./bin/rake remote:action:delete[CollectionObject,pp_photos1]

./bin/rake remote:action:delete[Relationship,all]
```

---