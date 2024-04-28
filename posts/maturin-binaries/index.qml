---
title: "Maturin Binaries"
author: "pixies"
date: "2024-04-28"
categories: []
---

I recently had a go at writing binaries that could be installed via `pypi` patterns via Rust. In general it demonstrates how you can expose tooling to the python ecosystem with no Python code at all! 

For example, this package: https://github.com/8bit-pixies/sortie is a basic maturin python package build, with 0 python code. The key "secret sauce" lies in this part of the configuration:

```
[tool.maturin]
bindings = "bin"
```

That is to say the package when exposed, is used via `python -m <pkg_name>`.

This has some interesting consequences, such as how tools like `ruff` and others are built with no or limited [Python library support](https://github.com/astral-sh/ruff/discussions/8539).

I _do_ like this trend (incl. `onnx`) where things are exposed from a production standpoint _not_ in Python and are offloaded elsewhere. 
