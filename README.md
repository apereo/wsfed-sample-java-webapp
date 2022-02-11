# WS Federation Sample Web Application

This is a sample application that acts as a WS Federation client using Apache Fediz.

## Build
   
You will need JDK 11.

```bash
./gradlew clean build 
```
   
## Run
    
You will need a keystore at `/etc/cas/thekeystore`.

```bash
./gradlew 
```
       
## Configuration
       
See:

- `WEB-INF/fediz.xml`
- `WEB-INF/applicationContext-security.xml`
                                          
