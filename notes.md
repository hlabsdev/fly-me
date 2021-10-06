# Hermann's note about Fly.io Full Stack Phoenix Hiring Project

## Live app link

[fly-me-ui](https://link)

## Source code

[Github repo here](https://github.com/H-Labs99/fly-me)

## What I've built

```
- I've  created a `fetch_appstatus` function in the `Client` module (client.ex)
- I've created the AppLive.Status live module in order to show the status on a liveView page
- I use the `fetch_appstatus` function in the `AppLive.Status` module to fecth the status of the app, and then pplug it in the final response 
- I've  created a date conversion function adn also a Timelapse parser in index, status and show.
```

## What I haven't built

```
- A Function for checking the number of checks and rendering their status 
- A really beautiful UI
- Checking if the app have a status data befor showing the "status" button
```

## How to determine if this is successfull

- the first thing to look out for here is that one must me able to see the status of his running app
- first we need to make people test it in different condition (many apps runings, many instance, some apps running with problems...)
- ask for feedback and pick the relevants ones in order to imporove the work


## Sugestions

- Maybe there is a problem with app deletion:
I've deleted an app in my dashboard but afterward it reapeared again, even though it told me the action was irreversible
