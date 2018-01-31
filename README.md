# PowerPlants

This software and hardware was developed over 36 hours at HoyaHacks, a Hackathon at Georgetown University by me and three teammates. 

We used PunchThrough's Light Blue Bean microprocessor which has an on board thermomometer as well as an auxilarary hydrometer to establish a serial connection to a phone over Bluetooth energy in real time. Upon opening our app with a nearby Bean, which we call the PowerSeed, users have the option to connect to the PowerSeed and enter information about their plant. Among the information users can enter, users can pick the category their plant falls into. Then, when users' phones are in range of the PowerSeed which is in the soil of the plant, the temperature and moisture data is sent to the phone every second. The meters displaying the temperature and moisture data show the current levels as well as the optimal temperature and mosture level. These optimizations are based on data from the University of Georgia which contains data on 230 different household plants. We organized plants into categories and analyzed the data accordingly. So, when users select the plant type, they are customizing the meters to their plant so the app can tell the user in real time whether the plant is under, over or optimally watered as well as if the ambient temperature is too low, too high or acceptable for the plant. This app combines powerful cloud based technology and specialized IOT-enabled sensor hardware to solve an everyday problem. 

My role in this project was to write and implement code for the Arduino, create a sync utility so the phone recieved the data from the Arduino, design the meters, and write code so that the meters' levels and optimizations adjusted based on the data from the sensors and the plant type.

In the future we hope to expand our add-on marketplace to include automated sprinklers, drip hoses, and more. 


<p align="center"> 
  <img src="https://user-images.githubusercontent.com/22032435/35482690-032a6f28-0407-11e8-992c-fffd347e006e.jpeg" width=50%>
  <img src="https://user-images.githubusercontent.com/22032435/35482683-e8f60004-0406-11e8-942f-371f2403de03.jpeg" width=50%>
  <img src="https://user-images.githubusercontent.com/22032496/35482471-dac65a4a-0403-11e8-8ed6-28ede422aacc.jpeg" width=50%>
  <img src="https://user-images.githubusercontent.com/22032435/35482737-687f5f32-0407-11e8-876f-b310b05a9ecc.jpeg" width=50%>
  <img src="https://user-images.githubusercontent.com/22032435/35482696-25aaab94-0407-11e8-9d54-9ea52503b41c.jpeg" width=50%>
</p>
