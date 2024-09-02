---
title: "A Simple Feature Store"
author: 8bit-pixies
author-url: "https://github.com/8bit-pixies/"
toc-title: Contents
---

# 2024 February 24

Feast is winding down (or at least Tecton is moving its maintainership status), I thought its time to re-think about "simple" feature stores. This isn't because I think Feast is going away or it will fade into obscurity, but rather rethink the patterns and how we manage production. 

## Scoping

Many feature platform solutions solve both the feature generation, online and offline retrieval of features. To simplify the problem space, what if we only want to deal with online retrieval and offline _storage_. In this case, we're ignoring the offline retrieval portion of the problem altogether. 

Although this massively reduces the scope of the problem, it also massively simplifies the problem space. 

## High Level Design

If we are focussed predominantly on the online retrieval portion of the feature store, then we are executing against a Kappa-style architecture. 

Batch Style Feature Publishing:

1. Run ETL job
2. Separate process to load into online store (e.g. Redis)

Streaming Style Feature Publishing:

1. Run streaming process
2. Load data into online store
3. Separate process to write data back to offline storage

The key component here, is deciding on the data model to manage these style of features. 

Some of the challenges in approaching things in this way is discerning between the different ways data is stored:

* as a slowly changing record (e.g. a customer's profile information)
* as an event record (e.g. a customer purchasing an item)

If we simplify our problem and pretend all information arriving is an event then our problem space becomes even easier.

## Data Model

> Data dominates. If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming. - Rob Pike

In the data model a machine learning takes in denormalised data. It is generally unnested so that variety of machine learning libraries can make use of it. Having it unnested also simplifies the pattern, because then data from different sources with different entity keys can be combined at inference time in a naive fashion. 

Then the target _offline_ data setup consists of two tables: 
- Feature Set (Latest)
- Feature Set (History)

We can model this (via Python dataclass notation):

```py
class FeatureSetHistory:
    id: int
    feature_set: Dict[str, FeatureValue]  # flatten this out in a table
    create_timestamp: datetime


class FeatureSetLatest:
    id: int
    feature_set: Dict[str, FeatureValue]  # flatten this out in a table
```

From an ETL perspective, both tables should be populated at the same time. The online setting will bulk unload the `FeatureSetLatest` information into the appropriate key-value store for online inference. 

This is equivalent to modeling data as an EAVT format

## Online Query

From an online query perspective, we would need some metadata which contains all possible feature sets, their entity infromation. Then the query would be:

```py
featureset_a, featureset_b, featureset_c = get_feature_set_by_entity_info(entity_info)
key_value_store.mget([featureset_a, featureset_b, featureset_c])
```

where `featureset_a`, `featureset_b`, `featureset_c`, is the appropriate key for the feature sets each keyed with the appropriate entity

## Publishing offline

Working backwards, now that we have a table of events we can unravel them to a more friendly data warehousing solution, we would have a continual ETL job which goes from EAVT to a SCD table, such as via a regular ETL process to populate the appropriate data warehouse. 

From a retrieval perspective, the data housing patterns should be used to manage the modeling workflows instead of natively using the EAVT structure. 

This also makes it plausible to build an appropriate retrieval SDK inhouse - you only need to worry about SCD style tables for each feature set rather than lots of different types of modeling tables. 

## Next Steps

Demo an application using `duckdb` as the base...

# 2024 March 4

See [Distiller](https://github.com/8bit-pixies/distiller/tree/main) as a demo

Distiller is a "drop-in" feature store project. It aims to generate SQL code using "good" defaults based on existing feature store implementations. 

It demonstrates that you do not need to set up any infrastructure (besides having access to an existing database)
to build machine learning pipelines. 

What it is:

- Just a SQL generation tool, using `sqlalchemy` (for now)
- Support multi-entity (or at least only if each feature group has one single entity, but entity types can be mixed)
- Support feature versioning (or update via a creation timestamp field)

What we aim to do:

- Provide SQL generation tools for offline feature retrieval
- Document the semantics and language used in Distiller
- (TODO) Provide SQL generation tools to create a batch online unload onto your favourite online serving tool
- (TODO) Provide an opinionated online serving interface
- (TODO) Have a sensible API

What we're not:

- Feature metadata store (though providing metadata is optional)
- Compute engine, offload that to a database!

Comparisons and Influences:

- vertex.ai for the data preprocessing standards. No need to support every possible pattern!
- feast community for the SQL templates

Future Ideas:

- The logic is fairly simple and can be ported away (i.e. not in Python). Perhaps we can move the logic to something else and then expose appropriate bindings to R, JavaScript, Java etc.
