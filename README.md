cspace-converter
===

Migrate denormalized or semi-structured data to CollectionSpace from CSV.

Getting Started
---

Ruby (2.x) & Rails are required. The database backend is MongoDB (3.2) and by default should be running on `localhost:27017`.

```
bundle install
```

Setup
---

Create the data directory and add the data files.

```
db/data/
├── cataloging.csv # custom CSV data file
└── ppsobjectsdata.csv # Past Perfect objects data file
```

**Run MongoDB**

```
# for local development / conversions
docker run --net=host --name mongo -d mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.

**Initial data import**

The general command is:

```
./import.sh [CS_CONV_BATCH] [CS_CONV_TYPE] [CS_CONV_PROFILE]
```

- `CS_CONV_BATCH` batch name
- `CS_CONV_TYPE` converter type (module)
- `CS_CONV_PROFILE` profile from type

```
./import.sh acq1 PBM acquisition
./import.sh cat1 PBM cataloging
./import.sh con1 PBM conservation
./import.sh val1 PBM valuationcontrol

./import.sh ppsaccession1 PastPerfect ppsaccessiondata
./import.sh ppsobjects1 PastPerfect ppsobjectsdata
```

For these commands to actually work you will need the data files in `db/data`.

**Using the console**

```
rails c
p = DataObject.first
puts p.to_cspace_xml("CollectionObject")
```

**Running the development server**

```
rails s
```

To fire jobs created using the ui:

```
rake jobs:work
```

License
---

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---