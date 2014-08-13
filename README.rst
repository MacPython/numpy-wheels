##################################
numpy-atlas-binaries wheel builder
##################################

Repository to build dual arch 32 / 64 bit numpy OSX wheels against ATLAS.

See ``README.md`` in ``numpy-atlas-binaries`` submodule for details.

To set the numpy version to build, set the ``NP_TAG`` variable in the
``.travis.yml`` file.

The wheels get uploaded to a `rackspace container
<http://a365fff413fe338398b6-1c8a9b3114517dc5fe17b7c3f8c63a43.r19.cf2.rackcdn.com>`_
to which we the MacPython owners have the API key.  The API key is encrypted to
this exact repo in the ``.travis.yml`` file, so the upload won't work for you
from another repo.  You can contact the MacPython team to get set up, by using
the github issues for this project, or use another upload service such as github
-- see for example Jonathan Helmus' `sckit-image wheels builder
<https://github.com/jjhelmus/scikit-image-ci-wheel-builder>`_
