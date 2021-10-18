###################################
Building and uploading numpy wheels
###################################

The wheel builds are currently done using Azure Pipelines and TravisCI, Appveyor is
not used and is disabled at this time.

**Build process pages**

- Azure Pipelines at
  https://dev.azure.com/numpy/numpy/_build?definitionId=8&_a=summary&view=runs

- Travis CI at
  https://app.travis-ci.com/github/MacPython/numpy-wheels/builds

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
* uploads the wheel to the appropriate release or nightly Anaconda repository.

The resulting wheels are self-contained and do not need any external
dynamic libraries apart from those provided as standard by OSX / Linux as
defined by the manylinux standard.


Triggering a build
==================

You will likely want to edit the ``azure-pipelines.yml`` and ``.travis.yml``
files to specify the ``BUILD_COMMIT`` before triggering a build - see below.

You will need write permission to the github repository to trigger new builds.
Contact us on the mailing list if you need this.

You can trigger a build by either of two methods:

* making a commit to the ``numpy-wheels`` repository (e.g. with ``git
  commit --allow-empty``) followed by a push of the desired branch.
* merging a pull request to the master branch

Which numpy commit does the repository build?
=============================================

PRs merged to this repo from a fork, and commits directly pushed to this repo
will build the commit specified in the ``BUILD_COMMIT`` at the top of the
``azure-pipelines.yml`` file, the wheels will be
uploaded to https://anaconda.org/multibuild-wheels-staging/numpy. The
``NIGHTLY_BUILD_COMMIT`` is built once a week (sorry for the misnomer),
and uploaded to https://anaconda.org/scipy-wheels-nightly/.
The value of ``BUILD_COMMIT`` can be any naming of a commit, including branch
name, tag name or commit hash.

Uploading the built wheels to pypi
==================================

When the wheels are updated, you can download them using the
``download-wheels.py`` script and then upload them using ``twine``. Things are
done this way so that we can generate hashes and the README files needed for a
release before putting the wheels up on PyPI. The ``download-wheels.py`` script
is run as follows::

    $ python3 tools/download-wheels.py 1.19.0 -w <path_to_wheelhouse>

Where ``1.19.0`` is the release version, The wheelhouse argument is optional
and defaults to  ``./release/installers``.

You will need beautifulsoup4_ and urllib3_ installed in order to run
``download-wheels.py`` and permissions in order to upload to PyPI.

.. _manylinux: https://www.python.org/dev/peps/pep-0513
.. _twine: https://pypi.python.org/pypi/twine
.. _beautifulsoup4: https://pypi.python.org/pypi/beautifulsoup4
.. _delocate: https://pypi.python.org/pypi/delocate
.. _auditwheel: https://pypi.python.org/pypi/auditwheel
.. _urllib3: https://pypi.python.org/pypi/urllib3
