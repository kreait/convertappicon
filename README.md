# convertappicon

**convertappicon** converts a pdf into multiple app icons. It is a macOS tool written in Swift and currently supports generating iOS icons. The easiest way is to execute it from a project target script phase inside of Xcode.

**IMPORTANT**: Put the master pdf file into the project right alongside the destination AppIcon with an additional tailing 'Pdf' asset name (see sample). You do *not* need to bundle/copy the pdf to the target itself.

## Background

Xcode supports (named) images from pdf assets for a long time, but sadly the app icon itself is an exeption: up to 18 png files have to be arranged manually inside of Xcode to provide a proper app icon.

Due to an app offering multiple, pre-defined app icons to the user as an alternative as well, this can be a cumbersome task.

For that reason, I've created this script during a hackathon as a proof of concept and then later moved from a pure bash/ImageMagick/scripting setup to a native Swift tool.

Feel free to ask questions, fork or create pull requests - [oliver.michalak@kreait.com](oliver.michalak@kreait.com)

## Synopsis

`convertappicon [-c] [-h] [-t] [-s iphone ipad marketing] APPICONSETPATH`

APPICONSETPATH : The last parameter is the (partial) path to the destination .appiconset folder. It will traverse down and tries to find the first matching subfolder.

-c : Will clean the target folder first.

-h : Will show this help.

-t : Test only, will print app icon path, master pdf path and all possible icons only.

-s : Select icon categories: 'iphone', 'ipad' or 'marketing' - if omitted all of them will be created.

## Sample

There is a sample project showing you how the tool is going to be integrated. It was setup in the following steps:

- create a new iOS project
- open the `Assets.xcassets` entry (a default `AppIcon` asset should already be set up but empty)
- add an new image asset and name it `AppIconPdf`
- from either Sketch or OmniGraffle export the sample Icon file into a pdf
- drag the pdf into the newly created AppIconPdf panel (optional: set scale to `Single Scale`)
- create a new (aggregation) target in the projects target list (see cross platform templates)
- within that target, create a new run script build phase
- enter the path to the `convertappicon` script and add the `${SRCROOT}` folder
- select the build target and build it, to run the conversion
- now the previously empty `AppIcon` asset contains all icons

Providing `${SRCROOT}` in a target build script is usually enough but if you have multiple icons, you must provide the full folder path.
