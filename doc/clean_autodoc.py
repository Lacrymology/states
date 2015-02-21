# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst

"""
Simple sphinx extension to remove ``_module.`` and ``_state``
from the autodoc outputs
"""

def process_docstring(app, what, name, obj, options, lines):
    import ipdb;ipdb.set_trace()

def process_signature(app, what, name, obj, options, signature, return_annotation):
    import ipdb;ipdb.set_trace()

def setup(app):
    app.connect("autodoc-process-docstring", process_docstring)
    app.connect("autodoc-process-signature", process_signature)
