import 'package:flutter/material.dart';
import 'package:graduation_project/features/facilities/data/models/facilities/facilities.model.dart';

class DescriptionFacilitiesTile extends StatelessWidget {
  const DescriptionFacilitiesTile({super.key, required this.facilitiesModel});

final FacilitiesModel facilitiesModel;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           facilitiesModel.name??'' ,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:const  TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        const  Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey,
              ),
              Text(
                'Nasr City' ?? '',
                maxLines: 2,
                style:  TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}
