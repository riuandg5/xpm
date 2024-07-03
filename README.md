# XPM - Xilinx Project Manager

A simple command line app in bash to generate project structure to develop FPGA (pl) projects, Embedded (ps) projects, and Combined (pspl) projects using Xilinx Tools.

-   Enables consistent project structrue.
-   Force source and revision control.

## Compatible With

-   Xilinx Vivado 2019.1
-   Xilinx SDK 2019.1
-   Git Bash for Windows

## Installation

-   Clone this (xpm) repo to your home (`~`) directory

    ```sh
    $ cd ~
    $ git clone https://github.com/riuandg5/xpm.git
    ```

-   Add the following to your `~/.bash_profile`
    ```sh
    # xpm
    export PATH=$PATH:~/xpm/src # append xpm directory to PATH
    alias xpm=xpm.sh            # enable you to call xpm instead of xpm.sh
    ```
-   Source `~/.bash_profile` to your current session
    ```sh
    $ source ~/.bash_profile
    ```

## Usage

```
$ xpm
Usage: xpm <project_name> [project_type]

[project_type]:  'pl'   for Vivado Project only (Default)
                 'ps'   for SDK Project only
                 'pspl' for Vivado + SDK project
```

## Project Structures

-   pl

    ```sh
    ex_pl
    │   .gitignore
    │   build_project.tcl
    │   README.md
    │
    ├───images
    ├───srcs
    │   ├───bd
    │   ├───constrs
    │   ├───ip
    │   └───sim
    └───vivado_project
    ```

-   ps

    ```sh
    ex_ps
    │   .gitignore
    │   build_workspace.tcl
    │   README.md
    │
    └───images
    ```

-   pspl

    ```sh
    ex_pspl
    │   README.md
    │
    ├───images
    ├───pl
    │   │   .gitignore
    │   │   build_project.tcl
    │   │
    │   ├───srcs
    │   │   ├───bd
    │   │   ├───constrs
    │   │   ├───ip
    │   │   └───sim
    │   └───vivado_project
    └───ps
            .gitignore
            build_workspace.tcl
    ```

## pl Project Guide

```sh
# create pl project
$ xpm ex_pl pl

# open vivado
$ cd ex_pl
$ vivado
```

### Setting Up The Vivado Project

1. Create Project

    - Set `Project Name` as `vivado_project`.
    - Set `Project Location` to `/ex_pl`.
    - Check `Create project subdirectory`.

2. Set `Project Type` as `RTL Project`.

3. Add Sources

    - Add source files from `srcs, sim, and ip (.xci file)` directories.
    - Create new source file but set location to:
        - `srcs` for design source
        - `sim` for testbenches/simulation source
    - Change `HDL Source For` option for testbenches/simulation sources to `Simulation only`.
    - Uncheck `Copy sources into project`.

4. Add Constraints

    - Add constraints files from `constrs (.xdc file)` directory.
    - Create new constraint file but set location to `constrs`.
    - Uncheck `Copy constraints into project`.

5. Set Default Part

6. Finish

### Project Development

-   Whenever you add a new file, remember to set the location to `srcs`, `sim`, or `constrs` as needed.
-   When adding an IP from the catalog, make sure to set `IP Location` as `ip`. See [Setting Default IP Location](#setting-default-ip-location).
-   When adding a BD, make sure to set `Block Design Directory` to `bd`. Also let Vivado manage the HDL wrapper for BD.
-   After development, make sure to regenerate and overwrite `build_project.tcl` script.
    -   Select `File > Project > Write Tcl`.
    -   Set output file location to `build_project.tcl` (overwrite).
    -   Check `Copy sources to new project` and `Recreate Block Design using TCL`.

### Re-building Project

```sh
$ cd ex_pl
$ git clean -Xdn # to preview which gitignored files will be removed
$ git clean -Xdf # to force removal of the above listed files
$ vivado -source build_project.tcl
```

### Setting Default IP Location

-   Setting `IP Location` as `ip` each time when adding a new IP from catalog is prone to mistakes.
-   Also setting default IP location in settings is a global setting and not a project specific setting. That is if `/proj/A/ip` is set as default IP location for `project A` then it will also be default for `project B` which means you may end up editing IP of project A while working in project B.
-   To avoid the above scenario, and force `Remote IP Location` practice, set the defautlt IP location to a `readonly/no access location` like:

    ```tcl
    # run the following tcl commands in Vivado TCL Console

    # create a directory at C:/Xilinx/Vivado/2019.1/NO_ACCESS_LOCATION
    file mkdir $env(XILINX_VIVADO)/NO_ACCESS_LOCATION

    # set permissions to no access [WINDOWS]
    exec icacls $env(XILINX_VIVADO)/NO_ACCESS_LOCATION /deny Everyone:(OI)(CI)(F)

    # verify no access permissions
    file mkdir $env(XILINX_VIVADO)/NO_ACCESS_LOCATION/test

    # now set this directory as default IP location

    # use the following to reset permissions [WINDOWS]
    # exec icacls $env(XILINX_VIVADO)/NO_ACCESS_LOCATION /reset /t /c
    ```

    Now if you miss to set the IP location to `ip` while adding a new IP from catalog then it will throw the error in TCL Console.

### Exporting Hardware Description File

-   Select `File > Export > Export Hardware`.
-   Check `Include bitstream`.
-   Export to location of `ps` project.

    > Note: Keep .hdf file in root of `ps` projects.

## ps Project Guide

```sh
# create ps project
$ xpm ex_ps ps

# open sdk
$ cd ex_ps
$ xsdk -workspace . -hwspec design.hdf
```

> Note: \*.hdf is the hardware description file exported from the pl project.

### Launching SDK (From Vivado)

-   Select `File > Launch SDK` in Vivado.
-   Set `Exported Location` to `ex_ps`.
-   Set `Workspace` to `ex_ps`.
-   Hardware platform will appear in the Project Explorer of SDK.

## Creating BSP

-   Select `File > New > Board Support Package`.
-   Give it a name and check `Use default location`.
-   Select `Hardware Platform`, `CPU cores`, and `BSP OS`.
-   BSP will appear in the Project Expolrer of SDK.
-   Modify `bsp > system.mss` as needed.

## Creating Application Project

-   Select `File > New > Application Project`.
-   Give it a name and check `Use default location`.
-   Select `OS Platform`, `Target Hardware`, `Target Software`, and `BSP`.
-   Select `Template` to start with.

### Re-building Project

```sh
$ cd ex_ps
$ git clean -Xdn # to preview which gitignored files will be removed
$ git clean -Xdf # to force removal of the above listed files
$ xsct build_workspace.tcl

# After opening of SDK, build all projects
```
