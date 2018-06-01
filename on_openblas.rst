# Updating OpenBLAS builds

A white-water ride...

## Windows

Get access to or clone : https://github.com/matthew-brett/build-openblas

Edit the OpenBLAS commit in the `appveyor.yml` file, and commit.

This results in zipped OpenBLAS archives at https://github.com/matthew-brett/build-openblas.  The archive names are from the OpenBLAS commit, the Mingw-w64 gcc version, and the bitness (32, 64).

Download these build zip files to your machine, and calculate the SHA 256 hexdigests with something like::

    curl -LO https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-v0.3.0_gcc7_1_0_win32.zip
    curl -LO https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-v0.3.0_gcc7_1_0_win32.zip
    shasum -a 256 openblas-v0.3.0*.zip

Modify the `.appveyor.yml` or `appveyor.yml` files in:

* https://github.com/MacPython/numpy-wheels
* https://github.com/MacPython/scipy-wheels

with the URLs of the new zip files (above), and the SHA 256 hex digests, e.g.::

    OPENBLAS_32: https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-5f998ef_gcc7_1_0_win32.zip
    OPENBLAS_64: https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com/openblas-5f998ef_gcc7_1_0_win64.zip
    OPENBLAS_32_SHA256: 0a12804b08d475179a0411936f509b44d7512f084b4a81c2fa3abe8c9ac4ee09
    OPENBLAS_64_SHA256: 8f11d8a5a79795a3a1ccb2326c979a0ca426e623eee93f8e35239e3c21e62cd6

These builds take a long time.  The 64 bit builds can take over 2 hours.

## Linux, OSX

See: https://github.com/MacPython/openblas-libs

These builds, a bit confusingly, have names from (from left to right, separated
by hyphens):

#. ``git describe`` run on the OpenBLAS commit in the submodule.  This commit
   in turn comes from the `BUILD_COMMIT` specification in `.travis.yml`.
#. result of `uname`;
#. the platform (``i686`` or ``x86_64``), maybe followed by a specified suffix.
#. The suffix above is, by default, empty on Linux, and comes from the SHA
   hexdigest of the GFortran archive for macOS.
