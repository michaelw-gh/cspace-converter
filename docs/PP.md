# PastPerfect

```
rake db:nuke

./import.sh pp_accession1 PastPerfect accessions PPSdata_accession
./import.sh pp_objects1 PastPerfect objects PPSdata_objects

rake remote:action:transfer[Acquisition,pp_accession1]
rake remote:action:transfer[CollectionObject,pp_objects1]

# after other transfers
rake relationships:generate[pp_accession1]
rake relationships:generate[pp_objects1]

rake remote:action:transfer[Relationship,all]
```

To undo:

```
rake remote:action:delete[Acquisition,pp_accession1]
rake remote:action:delete[CollectionObject,pp_objects1]

rake remote:action:delete[Relationship,all]
```

---