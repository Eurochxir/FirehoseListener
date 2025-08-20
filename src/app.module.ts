import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { FirehoseListenerService } from './service/firehose-listener/firehose-listener.service';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, FirehoseListenerService],
})
export class AppModule {}
