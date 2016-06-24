# PBM

Migration for PBM using the `rake` tasks. Serves as example.

## Summary

The PBM converter has a one-to-one relationship between input csv file and procedure (i.e. [file] "pbm_acquisition" => [profile] "acquistion" => [procedure] "Acquisition"). The non-cataloging csv files contain an `objectNumber` field that "points at" a related cataloging record (in the "pbm_cataloging" csv file).

### Process

```
# import PBM batch using PBM converter, PBM converter profile, PBM csv file
./import.sh pbm_acq1 PBM acquisition pbm_acquisition
./import.sh pbm_cat1 PBM cataloging pbm_cataloging
./import.sh pbm_con1 PBM conservation pbm_conservation
./import.sh pbm_val1 PBM valuationcontrol pbm_valuationcontrol

# transfer PBM data to CollectionSpace
rake remote:action:transfer[Acquisition,pbm_acq1]
rake remote:action:transfer[CollectionObject,pbm_cat1]
rake remote:action:transfer[Conservation,pbm_con1]
rake remote:action:transfer[ValuationControl,pbm_val1]

rake remote:action:transfer[Person,all]
rake remote:action:transfer[Place,all]
rake remote:action:transfer[Taxon,all]

#- AFTER procedures have been transferred relationships can be created -#

# generate relationships for PBM batch
rake relationships:generate[pbm_acq1]
rake relationships:generate[pbm_con1]
rake relationships:generate[pbm_val1]

# transfer PBM relationships to CollectionSpace
rake remote:action:transfer[Relationship,all]
```

To "undo" the transfers use the delete task:

```
# delete transfers
rake remote:action:delete[Acquisition,pbm_acq1]
rake remote:action:delete[CollectionObject,pbm_cat1]
rake remote:action:delete[Conservation,pbm_con1]
rake remote:action:delete[ValuationControl,pbm_val1]

rake remote:action:delete[Person,all]
rake remote:action:delete[Place,all]
rake remote:action:delete[Taxon,all]

# delete transfer relationships
rake remote:action:delete[Relationship,all]
```

Post migration always ensure that record counts match expectations.

---