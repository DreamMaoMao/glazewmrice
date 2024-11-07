import React, {
    useState,
    useEffect
} from 'react';
import {createRoot} from 'react-dom/client';
import * as zebar from 'zebar';
import moment from "moment";


let showNetSpeed = false
let extraTitle = "..."
let glazewmTitle = "..."

const providers = zebar.createProviderGroup({
    network: { type: 'network',refreshInterval:2000  },
    glazewm: { type: 'glazewm' },
    cpu: { type: 'cpu',refreshInterval:2000 },
    date: { type: 'date', formatting: 'HH:mm' },
    battery: { type: 'battery' },
    memory: { type: 'memory',refreshInterval:2000 },
});

createRoot(document.getElementById('root')).render(<App />);

function App() {
    const [output, setOutput] = useState(providers.outputMap);
    const [dateFormat, setDateFormat] = useState('HH:mm');

    useEffect(() => {
      providers.onOutput(() => setOutput(providers.outputMap));
    }, []);

    const handleWheel = (event) => {
      // rolldown
      if (event.deltaY > 0) {
        output.glazewm.runCommand(
          `focus --next-active-workspace`)
      } else if (event.deltaY < 0) {
        //  rollup
        output.glazewm.runCommand(
          `focus --prev-active-workspace`)
      }
    };

    function getTitle() {
      let targeTitle
      if (output.glazewm?.focusedContainer.type == "window") {
        if (output.glazewm?.focusedContainer.title != glazewmTitle) {
          glazewmTitle = output.glazewm?.focusedContainer.title
          targeTitle = glazewmTitle
          extraTitle = glazewmTitle
        } else {
          targeTitle = extraTitle;
        }

      } else {
        targeTitle = "";
      }
      return (
            <span className="current-window">{targeTitle}</span>
          );
    }

    function getClashState() {
      const [isConnected, setIsConnected] = useState(null);

      const checkConnection = () => {
        const controller = new AbortController();
        const signal = controller.signal;

        fetch("http://127.0.0.1:7890", {
          mode: 'no-cors',
          signal
        })
          .then(() => {
            setIsConnected(true);
          })
          .catch(() => {
            setIsConnected(false);
          });

        // 设置超时
        setTimeout(() => {
          controller.abort();
        }, 1000); // 1秒超时
      };

      useEffect(() => {
        checkConnection();
        const interval = setInterval(checkConnection, 3000);

        return () => clearInterval(interval);
      }, []);
      return (
        <div>
          {isConnected === null && <div></div>}
          {isConnected === true && <button 
            onClick={() =>
                    output.glazewm.runCommand(
                      `shell-exec C:\\Users\\wuruq\\scoop\\apps\\clash-verge-rev\\current\\Clash Verge.exe`,
                    )
                  }
            className="clash-open">🚀</button>
          }
          {isConnected === false && <div className="clash-close"></div>}
        </div>
      );

      // if (clashIsOpen == "opened") {
      //   return (
      //   <div>
      //     {clashIsOpen === "opened" && <button 
      //       onClick={() =>
      //               output.glazewm.runCommand(
      //                 `shell-exec D:\\Program Files\\Clash for Windows\\Clash for Windows.exe`,
      //               )
      //             }
      //       className="clash-open">🚀</button>
      //     }
      //   </div>
      //     );          
      // } else {
      //   return (
      //   <div>
      //   </div>
      // );
      // }

    }

    // Get icon to show for how much of the battery is charged.
    function getBatteryIcon() {
      if (output.battery?.chargePercent > 90)
        return <i className="nf nf-fa-battery_4"></i>;
      if (output.battery?.chargePercent > 70)
        return <i className="nf nf-fa-battery_3"></i>;
      if (output.battery?.chargePercent > 40)
        return <i className="nf nf-fa-battery_2"></i>;
      if (output.battery?.chargePercent > 20)
        return <i className="nf nf-fa-battery_1"></i>;
      return <i className="nf nf-fa-battery_0"></i>;
    }

    // Get icon to show for current weather status.
    function getWeatherIcon() {
      switch (output.weather.status) {
        case 'clear_day':
          return <i className="nf nf-weather-day_sunny"></i>;
        case 'clear_night':
          return <i className="nf nf-weather-night_clear"></i>;
        case 'cloudy_day':
          return <i className="nf nf-weather-day_cloudy"></i>;
        case 'cloudy_night':
          return <i className="nf nf-weather-night_alt_cloudy"></i>;
        case 'light_rain_day':
          return <i className="nf nf-weather-day_sprinkle"></i>;
        case 'light_rain_night':
          return <i className="nf nf-weather-night_alt_sprinkle"></i>;
        case 'heavy_rain_day':
          return <i className="nf nf-weather-day_rain"></i>;
        case 'heavy_rain_night':
          return <i className="nf nf-weather-night_alt_rain"></i>;
        case 'snow_day':
          return <i className="nf nf-weather-day_snow"></i>;
        case 'snow_night':
          return <i className="nf nf-weather-night_alt_snow"></i>;
        case 'thunder_day':
          return <i className="nf nf-weather-day_lightning"></i>;
        case 'thunder_night':
          return <i className="nf nf-weather-night_alt_lightning"></i>;
      }
    }

    function showSsid() {
      if (showNetSpeed == false && output?.network.defaultInterface?.type == "wifi" && output?.network.defaultGateway != null && output?.network.defaultGateway.ssid != null) {
        return <div className="ssid">{output?.network.defaultGateway.ssid}</div>;
      } else {
        return <div className="ssid"></div>;
      }
    }

    function getSpeedConver() {

      if (showNetSpeed == false) {
        switch (output?.network.defaultInterface?.type) {
          case 'ethernet':
            return <img src="./icons/icons8-wired-network-32.png" className="i-wifi" width="19" height="19"></img>;
          case 'wifi':
            if (output?.network.defaultGateway?.signalStrength >= 75) {
              return <img src="./icons/icons8-wifi-3-32.png" className="i-wifi" width="19" height="19"></img>;
            } else if (
              output?.network.defaultGateway?.signalStrength >= 45
            ) {
              return <img src="./icons/icons8-wifi-2-32.png" className="i-wifi" width="19" height="19"></img>;
            } else if (
              output?.network.defaultGateway?.signalStrength >= 5
            ) {
              return <img src="./icons/icons8-wifi-1-32.png" className="i-wifi" width="19" height="19"></img>;
            } else {
              return <img src="./icons/icons8-no-network-32.png" className="i-eth" width="19" height="19"></img>;
            }
          default:
            return (
              <img src="./icons/icons8-no-network-32.png" className="i-eth"  width="19" height="19"></img>
            );
        }
        // return (
        //   <span>
        //     🌎{output?.network.defaultInterface.friendlyName}
        //   </span>
        // );
      }

      let fixnum = output.network.traffic.received.siUnit == "kB" ? 0: 1;

      const upspeed = (output.network.traffic.transmitted.siValue).toFixed(fixnum);
      const downspeed = (output.network.traffic.received.siValue).toFixed(fixnum);
      let final_down = 0.00
      let final_down_unit = "kB"
      let final_up = 0.00
      let final_up_unit = "kB"
      if (output.network.traffic.received.siUnit == "B") {
        final_down = 0.00
        final_down_unit = "kB"
      } else {
        final_down = downspeed
        final_down_unit = output.network.traffic.received.siUnit
      }
      if (output.network.traffic.transmitted.siUnit == "B") {
        final_up = 0.00
        final_up_unit = "kB"
      } else {
        final_up = upspeed
        final_up_unit = output.network.traffic.transmitted.siUnit
      }

      return (
        <span className="speedmode">
          <span className="downspeed">
            ⬇{final_down}{final_down_unit}/s
          </span>
          <span className="upspeed">
            ⬆{final_up}{final_up_unit}/s
          </span>
        </span>
      );
    }

    return (
      <div className="app">
        <div className="center">


        </div>

        <div className="left">



          {output.glazewm && (
            <div className="workspaces" onWheel={handleWheel}>
              {output.glazewm.currentWorkspaces.map(workspace => (
                <button
                  className={`workspace ${workspace.hasFocus && 'focused'} ${workspace.isDisplayed && 'displayed'}`}
                  onClick={() =>
                    output.glazewm.runCommand(
                      `focus --workspace ${workspace.name}`,
                    )
                  }
                  key={workspace.name}
                >
                  {workspace.displayName ?? workspace.name}
                </button>
              ))}
            </div>
          )}
          </div>

        <div className="right">
          {output.network && (
            <button className="netspeed"
            onClick={() =>
                  showNetSpeed = !showNetSpeed
                  }
            >
              {getSpeedConver()}
              {showSsid()}
            </button>
          )}

            {true && (
              <div className="clash">
                {getClashState()}
              </div>
            )}

            
            {output.glazewm && (
              <>
                {output.glazewm.bindingModes.map(bindingMode => (
                  <button
                    className="binding-mode"
                    key={bindingMode.name}
                  >
                    {bindingMode.displayName ?? bindingMode.name}
                  </button>
                ))}


                <button
                  className='tiling-direction'
                  onClick={() =>
                    output.glazewm.runCommand(`toggle-tiling-direction`)
                  }
                >{output.glazewm.tilingDirection === 'horizontal' ? '⮂' : '⮃'}</button>
              </>
            )}

          <button className='date'
                  onClick={() =>
                    dateFormat === 'HH:mm' ? setDateFormat('ddd MMM/DD HH:mm') : setDateFormat('HH:mm')
                  }

              >⏰{moment(output.date?.now).format(dateFormat)}
          </button>

          <button className="memory"
          onClick={() =>
                    output.glazewm.runCommand(
                      `shell-exec explorer`,
                    )
                  }
          >💾
            {Math.round(output.memory?.usage)}%
          </button>

          <button 
          onClick={() =>
                    output.glazewm.runCommand(
                      `shell-exec taskmgr`,
                    )
                  }
          className="cpu">📊


            {/* Change the text color if the CPU usage is high. */}
            <span
              className={output.cpu?.usage > 85 ? 'high-usage' : 'usage'}
            >
              {Math.round(output.cpu?.usage)}%
            </span>
          </button>

          {output.battery && (
            <button 
            onClick={() =>
                    output.glazewm.runCommand(
                      `shell-exec pythonw D:\\project\\wpm\\main.py`,
                    )
                  }
            className="battery">🔋
              {Math.round(output.battery?.chargePercent)}%
            </button>
          )}

          {output.weather && (
            <div className="weather">
              {getWeatherIcon()}
              {Math.round(output.weather.celsiusTemp)}°C
            </div>
          )}
        </div>
      </div>
    );
  }