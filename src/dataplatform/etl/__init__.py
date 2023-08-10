# from .demo_elt import DemoEtl
# from .demo_params import DemoParams
# from .my_filter_transformer import MyFilterTransformer
#
# __all__ = [
#     "DemoParams",
#     "DemoEtl",
#     "MyFilterTransformer",
# ]

# IMHO importing to higher levels like this makes sense for libraries like spetlr where library usage matters,
# but in a case like this where it is more about readability of the library I prefer that everything only lives in its
# own code file.
# Also, realtive imports make it impossible to copy-past code. The python foundation recommends against their usage.
# /Simon
