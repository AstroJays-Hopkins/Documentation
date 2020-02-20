# Specifications

If you want to read the documentation, you should go [here]( https://astrojays-hopkins.github.io/Documentation/docs/).
This repository is for the documentation source files.

## Development

This is a CI (continuous integration) enabled project. This means that your
contributions will be automatically tested to ensure they build correctly
before being allowed into the repo. It also means that the live website will
automatically update as soon as your changes are accepted.

### Prereqs

- An "extended" Hugo installation (Download [here](https://gohugo.io/getting-started/installing/))
- NPM - Included with Node.js (Download [here](https://nodejs.org/en/))

### Development Setup

1. Ensure you can run `hugo` and `npm` from the console of your choice. On
   windows, this will probably be `powershell`. On mac, this will probably be
   `terminal`. On Linux, this is any terminal emulator, including a bare vtty.
   If you can't run these commands, you might need to add them to your path. See
   the relevant OS documentation for more info.
2. Clone this repository and change directories into it.
3. Initialize the git submodule by running `git submodule update --init
   --recursive`
4. Run `npm install`.
5. Run`hugo server` to start the dev server. You should be able to view a local
   copy of this website at http://localhost:1313/Documentation/

### Tips

1. Run the spellchecker (`npx cspell --config .ci/cspell.json 'content/**/*.md'`)
   before submitting your changes. The build will fail if
   you have any spelling errors or words it doesn't know about and you'll have to
   fix them.
2. Always view your changes on the local server before submitting. If you
   changes cause a render failure, you will also have to redo them.

### Layout

- All documentation lives in the folder content/docs
- All CI configuration files and scripts live in the .ci folder. The only
  file you should edit here, unless you know exactly what you are doing, is
  the `dict.txt` file. Please add yoru custom dictionary entries in alphabetical
  order, preserving the current ordering. You should probably study these files
  so you learn how CI works
- The Github workflow config file is located in `.github/workflows`. This
  configure Github's built-in CI runner.
