# <bitbar.title>2533</bitbar.title>
# <bitbar.version>1.0</bitbar.version>
# <bitbar.author>mingelz</bitbar.author>
# <bitbar.author.github>mingelz</bitbar.author.github>
# <bitbar.desc>2533 Program</bitbar.desc>
date1=`date +%s`;
date2=`date -j -f %Y%m%d +%s 20250301`;
delta=$(((date2-date1)/(24*60*60)));
echo "2533(${delta})";
