import { Test, TestingModule } from '@nestjs/testing';
import { FirehoseListenerService } from './firehose-listener.service';

describe('FirehoseListenerService', () => {
  let service: FirehoseListenerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [FirehoseListenerService],
    }).compile();

    service = module.get<FirehoseListenerService>(FirehoseListenerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
