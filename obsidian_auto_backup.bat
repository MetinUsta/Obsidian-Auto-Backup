@echo off

:: Setting mydate and mytime variables to use them in commit message
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%a)
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a:%%b)

:: Saving the current working directory.
pushd .

:: Changing directory to the git repository which contains the obsidian notes.
cd "PATH/TO/YOUR/OBSIDIAN/VAULT"

:: Checking if there is nothing to commit
git status | findstr /C:"nothing to commit, working tree clean" > NUL

:: If there are changes, notify the user
if errorlevel 1 (
    echo Found changes
) else (
    ::If there are no changes, cancel the process and exit with status code 1.
    echo Branch is clean, canceling the process.
    popd
    exit /b 1
)

:: Add all changes to the staging area.
git add .

:: Commit changes
git commit -m "%mydate%_%mytime%" > NUL 2>&1

:: If commit fails exit with status code 1
if errorlevel 1 (
    echo Commit failed. Canceling the process.
    popd
    exit /b 1
) else (
    echo Commit successful.
)

:: Push changes to the remote repository
git push origin <YOUR BRANCH NAME> > NUL 2>&1

:: If push fails exit with status code 1
if errorlevel 1 (
    echo Push failed.
    popd
    exit /b 1
) else (
    echo Push successful.
)

popd