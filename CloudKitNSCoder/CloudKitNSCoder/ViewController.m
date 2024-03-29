//
//  ViewController.m
//  CloudKitNSCoder
//
//  Created by Juan Martín Noguera on 1/9/14.
//  Copyright (c) 2014 Juan Martín Noguera. All rights reserved.
//

@import CloudKit;
@import CoreLocation;

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *lastKnowPosition;
}


@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self warmupGPS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)magicButtonAction:(id)sender {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"wargames-05"
                                                                       ofType:@"jpg"]];
    CKAsset *img = [[CKAsset alloc]initWithFileURL:url];

    // vale aqui hacemos todono es el ideal pero estamos en beta
    CKRecord *regitro   = [[CKRecord alloc]initWithRecordType:@"Fotos"];
    
    regitro[@"locationImage"] = lastKnowPosition;
    regitro[@"image"] = img;
    regitro[@"Nombre"] = @"Nombre";
    
    // vamos a guardar el registro en la base de datos publica
    CKDatabase *publicDb = [[CKContainer defaultContainer]publicCloudDatabase];
    [publicDb saveRecord:regitro completionHandler:^(CKRecord *record, NSError *error) {
        
        if (error) {
            NSLog(@"Zas en toda la boca -> %@", error);
        }
    }];
    
}

- (IBAction)moreMagicButton:(id)sender {
    
    // vamos hacer una query a un registro
    
    CKDatabase *publicDb = [[CKContainer defaultContainer]publicCloudDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(locationImage, %@) < 100", lastKnowPosition];
    CKQuery *query = [[CKQuery alloc]initWithRecordType:@"Fotos" predicate:predicate];
    
    [publicDb performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"Resultado -> %@", results);
            for (CKRecord *place in results) {
                NSLog(@"Place -> %@", place[@"locationImage"]);
            }
        }
    }];
    
    
    
    
}

- (IBAction)vuduButtonAction:(id)sender {
    
    
    CKRecordID *vuduID = [[CKRecordID alloc]initWithRecordName:@"vuduID"];
//    CKRecord *vuduRecord = [[CKRecord alloc]initWithRecordType:@"Vudus" recordID:vuduID];
    CKRecord *vuduRecord = [[CKRecord alloc]initWithRecordType:@"Vudus"];
    
    vuduRecord[@"fechaVudu"] = [NSDate date];
    
    CKDatabase *pubDataBase = [[CKContainer defaultContainer]publicCloudDatabase];
    
    [pubDataBase saveRecord:vuduRecord
          completionHandler:^(CKRecord *record, NSError *error) {
              
              if (error) {
              
                  NSLog(@"Error -> %@", error);
              }
          }];
    
    // ejemplo fetch
    
    [pubDataBase fetchRecordWithID:vuduID completionHandler:^(CKRecord *record, NSError *error) {
        if (!error) {
            NSLog(@"Registro -> %@", record);
        }
    }];
}

#pragma mark - corelocation

- (void)warmupGPS{
    
    
    if ([CLLocationManager locationServicesEnabled] == YES) {
        locationManager = [[CLLocationManager alloc]init];

        CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            
             [locationManager requestWhenInUseAuthorization];
        }
           }
    if (locationManager) {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        [locationManager startUpdatingLocation];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Status -> %d", status);
    if (status == kCLAuthorizationStatusNotDetermined) {
        
//        [manager requestWhenInUseAuthorization];
        [manager requestAlwaysAuthorization];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error -> %@", error);
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
  
    lastKnowPosition = locations[0];
    [manager stopUpdatingLocation];
}




@end



// prueba zonas
//NSLog(@"Registro Vudu almacenado");
//
////lo guardamos en una zona privada Esto es una prueba NO HACER
//CKRecordZone *vuduZone = [[CKRecordZone alloc]initWithZoneName:@"VuduZone"];
//
//CKDatabase *privaDataBase = [[CKContainer defaultContainer]privateCloudDatabase];
//
//CKRecord *recordPriva = [[CKRecord alloc]initWithRecordType:@"Vudu"
//                                                     zoneID:[vuduZone zoneID]];
//[privaDataBase saveRecord:recordPriva completionHandler:^(CKRecord *record, NSError *error) {
//    if (!error) {
//        NSLog(@"Registro Vudu almacenado en privado y zona privada");
//    }
//    
//    
//}];
