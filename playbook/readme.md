# WINDDOWS | set %PATH%
```
$pipPath = $env:LocalAppData + "\Packages\" + (ls "$env:LocalAppData\Packages\PythonSoftwareFoundation.Python.3.12_*").name 
$env:PATH += ";$pipPath\LocalCache\local-packages\Python312\Scripts"
```

# INSTALL V1 | install required python libs
```
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org crowdstrike-falconpy
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org p2j
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org networksdb
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pandas
```

# INSTALL V2 |  download the whl packages
```
# go to https://pypi.org/project/msticpy/
pip install msticpy.whl -f ./ --no-index --no-deps
```
