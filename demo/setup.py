from setuptools import find_packages, setup

setup(
    name="data-platform-demo",
    version="1.0",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    package_data={"": ["*.sql", "*.yml", "*.yaml"]},
    install_requires=["atc-dataplatform==1.1.56"],
    description="Pyspark Library for demo",
    python_requires=">=3.8",
    entry_points={
        "demo_elt": ["demo_elt = dataplatform.etl.demo_elt:run_etl"],
    },
)
