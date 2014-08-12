##################
numpy-atlas-binaries wheel builder
##################

Repository to build numpy-atlas-binaries wheels.

By default the repo builds the latest tag (the tag on the branch most recently
branched from master - see http://stackoverflow.com/a/24557377/1939576). If you
want to build a specific commit:

* Comment out the line ``- LATEST_TAG=1`` in .travis.yml
* Update numpy-atlas-binaries submodule with version you want to build:

    * cd numpy-atlas-binaries && git pull && git checkout DESIRED_COMMIT
    * cd .. && git add numpy-atlas-binaries
    * git commit


The wheels get uploaded to a `rackspace container
<http://a365fff413fe338398b6-1c8a9b3114517dc5fe17b7c3f8c63a43.r19.cf2.rackcdn.com>`_
to which I have the API key.  The API key is encrypted to this specific repo
in the ``.travis.yml`` file, so the upload won't work for you from another
account.  Either contact me to get set up, or use another upload service such as
github - see for example Jonathan Helmus' `sckit-image wheels builder
<https://github.com/jjhelmus/scikit-image-ci-wheel-builder>`_

I got the rackspace API key from Olivier Grisel - we might be able to share
this account across projects - again - please contact me or Olivier if you'd
like this to happen.
