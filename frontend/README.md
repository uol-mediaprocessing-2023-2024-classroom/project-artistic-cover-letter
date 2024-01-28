# Frontend Demo

## Setup

1. First, Node.js must be installed. For Windows, an installer can be used: https://nodejs.org/en/download/
2. Now, the dependencies can be installed: ```npm install```
3. (If an error is displayed when starting: ```npm install @vue/cli-service -g```)

## Compile and Start
```npm run serve```
<br>
After starting, the site can be accessed via localhost.
<br>

## About the App
<p>This repository contains the frontend of the simple demo app. The frontend uses Vue and the Vuetify framework (Version 2), which offers many functionalities as well as pre-made Vue components.</p>
<p>To use the app, a CEWE myPhotos account is required (https://www.cewe-myphotos.com/en-gb/). In the 'Username' and 'Password' fields of the app, the username and password of the CEWE account must be entered, after which the photos from the account can be loaded into the app using 'Load Images'.</p>
<p>The "Apply Blur" button sends a request that sends the selected image to the local backend (located in this repository: https://github.com/uol-mediaprocessing-2023-2024-classroom/web_app_demo_backend) and waits for a response.
<br>

<strong>Important</strong>: Before shutting down the server, you should log out; otherwise, the client remains logged into the CEWE API without the necessary clId to log out.
This will happen automatically after one hour, but until then, you cannot log in again.</p>

## Links
<p>
Vue docs: https://vuejs.org/guide/introduction.html#what-is-vue<br>
Vuetify docs: https://v2.vuetifyjs.com/en/getting-started/installation/#webpack-install
</p>