Files here are from the prototype written for IIQSR-869. This is intended
to be abstracted for any bug. However specific data may still reference
sr869.

First thing that needs to be done for mass fixing is determine which tags
will need to be built for. use somethin glike

for /f %i in (list of tags)
    git diff --compact-summary [tag1] [tag2] filename

to determine what tags had changes. With that list, figure out which hash will
be used to cherry-pick into each of those hashes. Create user.properties
files for each of those hashs and tags. Also, build securityFixData to
describe which tag uses which of those properties.
