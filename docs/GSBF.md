# GSBF

Migration for GSBF using the `rake` tasks. Serves as example.

## Summary

Structurally this is very similar to the [PBM](#) example. Some differences:

- Multiple csv documents per profile (tree and pot)
- Reciprocal relationships between Cataloging records (tree and pot)

### Process

```
# import GSBF batch using GSBF converter, GSBF converter profile, GSBF csv file
./import.sh gsbf_tree_acq GSBF acquisition gsbf_acquisition
./import.sh gsbf_pot_acq GSBF acquisition gsbf_pot_acquisition
./import.sh gsbf_tree_cat GSBF cataloging gsbf_cataloging
./import.sh gsbf_pot_cat GSBF cataloging gsbf_pot_cataloging
./import.sh gsbf_tree_cc GSBF conditioncheck gsbf_conditioncheck
./import.sh gsbf_tree_con GSBF conservation gsbf_conservation
./import.sh gsbf_tree_lno GSBF loanout gsbf_loanout
./import.sh gsbf_tree_obj GSBF objectexit gsbf_objectexit
./import.sh gsbf_pot_val GSBF valuationcontrol gsbf_pot_valuation

# transfer GSBF data to CollectionSpace
rake remote:action:transfer[Acquisition,gsbf_tree_acq]
rake remote:action:transfer[Acquisition,gsbf_pot_acq]
rake remote:action:transfer[CollectionObject,gsbf_tree_cat]
rake remote:action:transfer[CollectionObject,gsbf_pot_cat]
rake remote:action:transfer[Conservation,gsbf_tree_con]
rake remote:action:transfer[ConditionCheck,gsbf_tree_cc]
rake remote:action:transfer[LoanOut,gsbf_tree_lno]
rake remote:action:transfer[ObjectExit,gsbf_tree_obj]
rake remote:action:transfer[ValuationControl,gsbf_pot_val]

rake remote:action:transfer[Organization,all]
rake remote:action:transfer[Person,all]
rake remote:action:transfer[Place,all]
rake remote:action:transfer[Taxon,all]

#- AFTER procedures have been transferred relationships can be created -#

# generate relationships for GSBF batch
rake relationships:generate[gsbf_tree_acq]
rake relationships:generate[gsbf_pot_acq]
rake relationships:generate[gsbf_pot_cat]
rake relationships:generate[gsbf_tree_con]
rake relationships:generate[gsbf_tree_cc]
rake relationships:generate[gsbf_tree_lno]
rake relationships:generate[gsbf_tree_obj]
rake relationships:generate[gsbf_pot_val]

# transfer GSBF relationships to CollectionSpace
rake remote:action:transfer[Relationship,all]
```

To "undo" the transfers use the delete task:

```
# delete transfers
rake remote:action:delete[Acquisition,gsbf_tree_acq]
rake remote:action:delete[Acquisition,gsbf_pot_acq]
rake remote:action:delete[CollectionObject,gsbf_tree_cat]
rake remote:action:delete[CollectionObject,gsbf_pot_cat]
rake remote:action:delete[Conservation,gsbf_tree_con]
rake remote:action:delete[ConditionCheck,gsbf_tree_cc]
rake remote:action:delete[LoanOut,gsbf_tree_lno]
rake remote:action:delete[ObjectExit,gsbf_tree_obj]
rake remote:action:delete[ValuationControl,gsbf_pot_val]

rake remote:action:delete[Organization,all]
rake remote:action:delete[Person,all]
rake remote:action:delete[Place,all]
rake remote:action:delete[Taxon,all]

# delete transfer relationships
rake remote:action:delete[Relationship,all]
```

Post migration always ensure that record counts match expectations.

---
