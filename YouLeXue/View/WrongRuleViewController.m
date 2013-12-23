//
//  WrongRuleViewController.m
//  YouLeXue
//
//  Created by vedon on 5/12/13.
//  Copyright (c) 2013 Vedon. All rights reserved.
//

#import "WrongRuleViewController.h"
static NSString * cellIndentifier = @"cellIdentifier";
@interface WrongRuleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataSource;
    NSMutableDictionary * dic;
    
    //
    UIImageView * checkImage;
    UIImageView * unCheckImage;
}
@end

@implementation WrongRuleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = @[@"1次",@"2次",@"3次",@"4次",@"5次"];
    dic = [NSMutableDictionary dictionary];
    
    for (int i =0; i<[dataSource count]; i++) {
        [dic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }
    checkImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Setting_Icon_Check@2x"]];
    unCheckImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Setting_Icon_UnCheck@2x"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureAction:(id)sender {
}

- (IBAction)cancelActioin:(id)sender {
}
- (void)viewDidUnload {
    [self setContentTable:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    if ([[dic objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]isEqual:@"0"]) {
        cell.accessoryView = unCheckImage;
    }else
    {
        cell.accessoryView = checkImage;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString * tempkey = [NSString stringWithFormat:@"%d",indexPath.row];
    for (NSString *key in dic.allKeys) {
        if ([key isEqualToString:tempkey]) {
            if ([[dic objectForKey:key]isEqual:@"0"]) {
                [dic setObject:@"1" forKey:tempkey];
            }else
            {
                [dic setObject:@"0" forKey:key];
            }
        }else
        {
            [dic setObject:@"0" forKey:key];
        }
    }
    [tableView reloadData];
    
    

}
@end
