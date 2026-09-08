# Platform data schema

One file per table (`<table>.md`) describing its columns, types, and descriptions.
Platform-tier because a table's shape isn't scoped to whichever domain reads or
writes it. Populated as sources state table structures; who may *write* each table is
a separate question, recorded in `platform/data-ownership.md`.

Ships empty. Template: the knowledge-curation skill's
`references/knowledge/data-schema.md`.
