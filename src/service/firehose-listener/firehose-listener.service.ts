import { Injectable, OnApplicationBootstrap, OnApplicationShutdown } from '@nestjs/common';
import { Firehose, MemoryRunner } from '@atproto/sync';
import { IdResolver, DidResolver } from '@atproto/identity';
import { AppBskyFeedPost } from '@atproto/api';

@Injectable()
export class FirehoseListenerService implements OnApplicationBootstrap, OnApplicationShutdown {
  private firehose: Firehose;
  private runner: MemoryRunner;

  onApplicationBootstrap() {
    console.log('Application bootstrapped');
    this.startListening();
  }

  async onApplicationShutdown(signal?: string) {
    console.log('Application shutting down, destroying firehose...');
    await this.firehose.destroy();
    await this.runner.destroy();
    console.log('Firehose destroyed.');
  }

  private startListening() {
    console.log('Starting firehose listener...');
    this.subscribeToFirehose();
  }

  private subscribeToFirehose() {
    this.runner = new MemoryRunner();
    const idResolver = new IdResolver({ timeout: 10000 });

    this.firehose = new Firehose({
      idResolver,
      runner: this.runner,
      service: 'wss://bsky.network',
      filterCollections: ['app.bsky.feed.post'],
      handleEvent: async (evt) => {
        try {
          // The firehose sends create, update, and delete events.
          // We need to make sure the record exists before we process it.
          if (!evt.record) {
            return;
          }

          const authorDid = evt.did;
          const post = evt.record as AppBskyFeedPost.Record;
          const text = post.text || '';

          if (text.toLowerCase().includes('coffee')) {
            const didResolver = new DidResolver({});
            const profile = await didResolver.resolveAtprotoData(authorDid);
            const authorHandle = profile?.handle || authorDid;
            console.log(`New post: ${authorHandle} - ${text}`);
          }
        } catch (error) {
          console.error('Error processing message:', error.message);
        }
      },
      onError: (err) => {
        console.error('Firehose error:', err);
      },
    });

    this.firehose.start();
    console.log('Subscribed to firehose...');
  }
}