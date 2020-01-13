import { WebPlugin, PluginListenerHandle, ListenerCallback } from '@capacitor/core';
import { BackgroundSchedulerPlugin, BackgroundTask, BackgroundTaskIdentifier } from './definitions';

export class BackgroundSchedulerWeb extends WebPlugin implements BackgroundSchedulerPlugin {
  constructor() {
    super({
      name: 'BackgroundScheduler',
      platforms: ['web']
    });
  }

  async schedule(options: BackgroundTask) {
    console.log('scheduling task ' + options.identifier);
  }

  async finished(options: BackgroundTask) {
    console.log('finished with task ' + options.identifier);
  }

  addListener(eventName: BackgroundTaskIdentifier, _listenerFunc: ListenerCallback) {
    console.log('adding listener for ' + eventName);
    return {remove: () => {}} as PluginListenerHandle;
  }

  /*
  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
  */
}

const BackgroundScheduler = new BackgroundSchedulerWeb();

export { BackgroundScheduler };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(BackgroundScheduler);
