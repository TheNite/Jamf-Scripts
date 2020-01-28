#!/bin/sh

###
#
#            Name:  Battery Cycle Count.sh
#     Description:  Returns cycle count of battery for notebooks
#                   (returns 0 for desktops).
#         Created:  2017-05-10
#   Last Modified:  2020-01-07
#         Version:  1.2
#
#
# Copyright 2017 Palantir Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
###



########## variable-ing ##########



powerReport=$(/usr/sbin/system_profiler SPPowerDataType)



########## main process ##########



# Count cycles (if computer has a battery).
if /bin/echo "$powerReport" | grep -q "Battery Information"; then
  cycleCount=$(/bin/echo "$powerReport" | /usr/bin/awk '/Cycle Count/ {print $NF}' | /usr/bin/bc)
else
  cycleCount=0
fi


# Report result.
/bin/echo "<result>$cycleCount</result>"



exit 0