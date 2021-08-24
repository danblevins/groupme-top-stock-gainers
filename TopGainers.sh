#!/bin/bash
# Put your API Key and Bot ID here
apikey=$"YOUR_API_Key"
bot_id=$"YOUR_BOT_ID"

final=($"Today's Top Gainers: \n")
# Curl the top stock gainers.
gainers=$(curl "https://financialmodelingprep.com/api/v3/stock/gainers?apikey=${apikey}")

# Loop to get the top 3 highest gainers based on yesterday's close.
for i in 0 1 2
do
    temp_name=$(jq -r  ".mostGainerStock[$i].companyName" <<< "${gainers}")
    temp_tick=$(jq -r  ".mostGainerStock[$i].ticker" <<< "${gainers}")
    temp_perc=$(jq -r  ".mostGainerStock[$i].changesPercentage" <<< "${gainers}" | sed 's/(//g' | sed 's/)//g' | sed 's/+//g')
    temp_price=$(jq -r  ".mostGainerStock[$i].price" <<< "${gainers}")
    google=$(curl "https://financialmodelingprep.com/api/v3/profile/${temp_tick}?apikey=${apikey}" | jq ".[].exchangeShortName" | sed 's/"//g')
    num=$((i+1))

    sentence=$" ${num}. ${temp_name} (Ticker: ${temp_tick}) is up ${temp_perc} at \$${temp_price} a share. Learn more: www.google.com/finance/quote/${temp_tick}:${google} \n"
    final+=${sentence}
done
echo $final

# Send the results to your GroupMe group.
curl -d '{ "text":"'"$final"'", "bot_id":"'"$bot_id"'" }' https://api.groupme.com/v3/bots/post
