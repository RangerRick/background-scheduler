import { PluginListenerHandle, ListenerCallback } from "@capacitor/core";

declare module "@capacitor/core" {
  interface PluginRegistry {
    BackgroundScheduler: BackgroundSchedulerPlugin;
  }
}

export type BackgroundTaskIdentifier = string;

export type BackgroundTaskResult = any;

export type BackgroundTaskCallback = () => any;

export type BackgroundTask = {
  identifier: BackgroundTaskIdentifier,
  type?: 'refresh' | 'processing',
}

export interface BackgroundSchedulerPlugin {
  schedule(options: BackgroundTask): void;
  // cancel(options: BackgroundTask): void;
  finished(options: BackgroundTask): void;
  addListener(eventName: BackgroundTaskIdentifier, listenerFunc: ListenerCallback): PluginListenerHandle;
}

