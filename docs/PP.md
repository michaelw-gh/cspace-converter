# PastPerfect

```
./bin/rake db:nuke

./import.sh pp_accession1 PastPerfect accessions PPSdata_accession
./import.sh pp_archives1 PastPerfect archives PPSdata_archives
./import.sh pp_library1 PastPerfect library PPSdata_library
./import.sh pp_objects1 PastPerfect objects PPSdata_objects
./import.sh pp_photos1 PastPerfect photos PPSdata_photos

./bin/rake remote:action:transfer[Acquisition,pp_accession1]
./bin/rake remote:action:transfer[CollectionObject,pp_archives1]
./bin/rake remote:action:transfer[CollectionObject,pp_library1]
./bin/rake remote:action:transfer[CollectionObject,pp_objects1]
./bin/rake remote:action:transfer[CollectionObject,pp_photos1]

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