# File batch operations

Set of tool for doing batch operations on a set of files. More info in comments of specific scripts. Here only rudimentary overview is provided.

## Getting started

It is possibly most convient to first put desired scripts in system path for easy use.
1. make sure all scripts are executable (```chmod``` +x if needed)
1. make symbolic links into /usr/bin without suffixes e.g.
```
sudo ln -s <path-to-script>for_each_subdir.sh /usr/bin/for_each_subdir
```

## for_each_subfolder

Main script that will iterate over all subdirectories from current path (place where it was called from) and apply action provided as argument. Action can be anything callable, few examples are provided in repository.

Read more in script comments.

## Examples of actions

* count_files.sh - print number of files
* convertto.sh - convert images to desired format
* jpg2pdf.sh - convert all jpg files into single pdf

If you want to use action scripts from any location install it in /usr/bin as explained in **Getting started** section.
