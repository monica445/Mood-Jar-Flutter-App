import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mood_jar_app/domain/entities/mood_entry.dart';

class MoodExpandableCard extends StatefulWidget {
  final MoodEntry mood;
  final VoidCallback? onEditTap;

  const MoodExpandableCard({super.key, required this.mood, this.onEditTap});

  @override
  State<MoodExpandableCard> createState() => _MoodEntryTileState();
}

class _MoodEntryTileState extends State<MoodExpandableCard> {
  bool _showReflection = false;

  @override
  Widget build(BuildContext context) {
    final reflection = widget.mood.reflection;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SvgPicture.asset(
              widget.mood.type.icon,
              colorFilter: ColorFilter.mode(
                widget.mood.type.color,
                BlendMode.srcIn,
              ),
              width: 45,
              height: 45,
            ),
            title: Text(
              widget.mood.type.label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('h:mm a').format(widget.mood.timestamp),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF7A7A7A)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.onEditTap != null)
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFFFAD089),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: widget.onEditTap,
                    tooltip: "Edit",
                  ),

                if (reflection != null)
                  IconButton(
                    icon: Icon(
                      _showReflection ? Icons.expand_less : Icons.expand_more,
                    ),
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _showReflection = !_showReflection;
                      });
                    },
                  ),
              ],
            ),

          ),

          if (_showReflection && reflection != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reflection.note != null &&
                      reflection.note!.isNotEmpty) ...[
                    const Text(
                      "Note",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(reflection.note!),
                    const SizedBox(height: 12),
                  ],

                  if (reflection.factors!.isNotEmpty) ...[
                    const Text(
                      "Factors",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reflection.factors!.map((factor) {
                        return Text(factor);
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

        ],
      ),
    );
  }
}
