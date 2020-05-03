###################################
Building and uploading numpy wheels
###################################

The wheel builds are currently done by Azure Pipelines. Options that may be
used for future builds are TravisCI and Appveyor. Note that currently TravisCI
and Appveyor are not triggered, if you want to enable them you will need to do
so in the settings/Webhooks.

**Build process pages**

- Azure Pipelines at
  https://dev.azure.com/numpy/numpy/_build?definitionId=8&_a=summary&view=runs

- Travis CI at
  https://travis-ci.org/MacPython/numpy-wheels

- The Appveyor at
  https://ci.appveyor.com/project/matthew-brett/numpy-wheels

- The driving github repository is
  https://github.com/MacPython/numpy-wheels

**Uploaded file locations**

- Release builds at
  https://anaconda.org/multibuild-wheels-staging/numpy/files

- Nightly builds at
  https://anaconda.org/scipy-wheels-nightly/numpy/files


How it works
============

The wheel-building repository:

* checks out either a known version of NumPy or master's HEAD
* downloads OpenBLAS using numpy/tools/openblas_support.py
* builds a numpy wheel, linking against the downloaded library and using
  the appropriate additional variables from `env_vars.sh` or `env_vars32.sh`
* processes the wheel using delocate_ (OSX) or auditwheel_ ``repair``
  (manylinux_).  ``delocate`` and ``auditwheel`` copy the required dynamic
  libraries into the wheel and relinks the extension modules against the
  copied libraries;
* uploads the built wheels to http://wheels.scipy.org (a Rackspace container
  kindly donated by Rackspace to scikit-learn).

The resulting wheels are therefore self-contained and do not need any external
dynamic libraries apart from those provided as standard by OSX / Linux as
defined by the manylinux standard.

The ``azure/*`` files in this repository read a token stored in the Azure
Pipeline used to run the CI.  This encrypted key gives Azure permission to
upload to the ananconda.org directories ``https://anaconda.org/<user>/numpy/``
where user is the ``ANACONDA_ORG`` value in the ``yml`` files.

Triggering a build
==================

You will likely want to edit the ``azure/*`` files to
specify the ``BUILD_COMMIT`` before triggering a build - see below.

You will need write permission to the github repository to trigger new builds.
Contact us on the mailing list if you need this.

You can trigger a build by:

* making a commit to the `numpy-wheels` repository (e.g. with `git
  commit --allow-empty`); or
* merging a pull request to the repo

Which numpy commit does the repository build?
===============================================

PRs merged to this repo from a fork, and commits directly pushed to this repo
will build the commit specified in the ``BUILD_COMMIT`` at the top of the
``azure/windows.yml`` and ``azure/posix.yml`` files, the wheels will be
uploaded to https://anaconda.org/multibuild-wheels-staging/numpy. The
``NIGHTLY_BUILD_COMMIT`` is built once a week (sorry for the misnomer),
and uploaded to https://anaconda.org/scipy-wheels-nightly/.
The value of ``BUILD_COMMIT`` can be any naming of a commit, including branch
name, tag name or commit hash.

Uploading the built wheels to pypi
==================================

When the wheels are updated, you can download them to your machine manually,
and then upload them manually to pypi, or by using twine_.  You can also use a
script for doing this, housed at :
https://github.com/MacPython/terryfy/blob/master/wheel-uploader

For the ``wheel-uploader`` script, you'll need twine and `beautiful soup 4
<bs4>`_.

You will typically have a directory on your machine where you store wheels,
called a `wheelhouse`.   The typical call for `wheel-uploader` would then
be something like::

    CDN_URL=https://anaconda.org/multibuild-wheels-staging/numpy/files
    wheel-uploader -r warehouse -u $CDN_URL -s -v -w ~/wheelhouse -t macosx numpy 1.19.0
    wheel-uploader -r warehouse -u $CDN_URL -s -v -w ~/wheelhouse -t manylinux1 numpy 1.19.0
    wheel-uploader -r warehouse -u $CDN_URL -s -v -w ~/wheelhouse -t win numpy 1.19.0

where:

* ``-r warehouse`` uses the upcoming Warehouse PyPI server (it is more
  reliable than the current PyPI service for uploads);
* ``-u`` gives the URL from which to fetch the wheels, here the https address,
  for some extra security;
* ``-s`` causes twine to sign the wheels with your GPG key;
* ``-v`` means give verbose messages;
* ``-w ~/wheelhouse`` means download the wheels from to the local directory
  ``~/wheelhouse``.

``numpy`` is the root name of the wheel(s) to download / upload, and
``1.19.0`` is the version to download / upload.

So, in this case, ``wheel-uploader`` will download all wheels starting with ``numpy-1.19.0-``
from https://anaconda.org/multibuild-wheels-staging/numpy/files to ``~/wheelhouse``,
then upload them to PyPI.

Of course, you will need permissions to upload to PyPI, for this to work.

.. _manylinux: https://www.python.org/dev/peps/pep-0513
.. _twine: https://pypi.python.org/pypi/twine
.. _bs4: https://pypi.python.org/pypi/beautifulsoup4
.. _delocate: https://pypi.python.org/pypi/delocate
.. _auditwheel: https://pypi.python.org/pypi/auditwheel
