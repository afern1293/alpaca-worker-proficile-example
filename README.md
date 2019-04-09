# reversion-algo
Heroku worker for reversion algorithm

## Setup

Set your environment variables in heroku.
Navigate to https://dashboard.heroku.com/apps/

From there go to settings and Reveal Config Vars.
In this section you will set your base_url, key, and secret for alpaca.
use the string before the `=` for the KEY and the string after as the VALUE.
```sh
export APCA_API_BASE_URL=bbb
export APCA_API_KEY_ID=xxx
export APCA_API_SECRET_KEY=yyy
```
After deployment navigate over to the Resources tab.
Here you will see a line that states 
`worker pylivetrader run -f reversion.py --data-frequency minute -b paper` followed by a switch, dollar amount, and pen.
Click the pen and move the slider. Click confirm to activate the worker.

## Verify
You can verify the app is running by navigating to the logs in your dashboard. 
To do this click the More drop down and select logs.
You should see output similar to:
```
2019-04-09T06:20:58.132013+00:00 app[api]: Scaled to worker@1:Free by user khays@csumb.edu
2019-04-09T06:21:10.019054+00:00 heroku[worker.1]: Starting process with command `pylivetrader run -f reversion.py --data-frequency minute -b paper`
2019-04-09T06:21:10.841619+00:00 heroku[worker.1]: State changed from starting to up
2019-04-09T06:21:13.341974+00:00 app[worker.1]: [heroku-exec] Starting
2019-04-09T06:21:24.059524+00:00 app[worker.1]: [2019-04-09 06:21:24.059296] INFO: Algorithm: livetrader start running with backend = paper data-frequency = minute
2019-04-09T06:21:25.793038+00:00 app[worker.1]: [2019-04-09 06:21:25.792790] DEBUG: reversion: Initializing...
2019-04-09T06:21:25.805833+00:00 app[worker.1]: [2019-04-09 06:21:25.805718] DEBUG: reversion: Done initializing.
```

You can also verify the logs through an ssh tunnel.
You will need the Heroku CLI at https://devcenter.heroku.com/articles/heroku-cli#download-and-install

launch a powershell and enter the following commands.
```
heroku login
heroku logs -a <app_name>
```
You will see a prompt 
```
heroku: Press any key to open up the browser to login or q to exit:
```
press any key besides q when prompted.

## Maintenance
All trading algorithms need routine maintenance.
Most algorithms need to run continuously without interruption to save variables accrued on the heap during its runtime.
We must make sure the algorithm is running cleanly to ensure we don't have to re-deploy (restart) the algorithm and lose the heap variables. 

After first trading day:
- verify successful run
- verify program did not exit

weekly:
- check for web_socket errors
- verify successful run
- verify program is trading at proper time intervals

