import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gpio_config.dart';
import '../cubit/gpio_cubit.dart';
import '../cubit/gpio_state.dart';

class GPIOPage extends StatelessWidget {
  const GPIOPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPIO Control'),
      ),
      body: BlocConsumer<GPIOCubit, GPIOState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.pins.isEmpty) {
            return const Center(child: Text('Add GPIO pins to get started'));
          }

          return ListView.builder(
            itemCount: state.pins.length,
            itemBuilder: (context, index) {
              final pin = state.pins[index];
              return ExpansionTile(
                title: Text('${pin.label} (Pin ${pin.pinNumber})'),
                subtitle: Text(pin.isInput ? 'Input' : 'Output'),
                trailing: pin.isInput
                    ? Icon(
                        pin.value
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: pin.value ? Colors.green : Colors.grey,
                      )
                    : Switch(
                        value: pin.value,
                        onChanged: (value) {
                          context.read<GPIOCubit>().togglePin(
                                pin.pinNumber,
                                value,
                              );
                        },
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pin Number: ${pin.pinNumber}'),
                        Text('Mode: ${pin.isInput ? 'Input' : 'Output'}'),
                        Text('Current Value: ${pin.value}'),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPinDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddPinDialog(),
    );
  }
}

class AddPinDialog extends StatefulWidget {
  const AddPinDialog({super.key});

  @override
  AddPinDialogState createState() => AddPinDialogState();
}

class AddPinDialogState extends State<AddPinDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pinNumberController;
  late TextEditingController _labelController;
  bool _isInput = true;
  bool _showAdvancedConfig = false;

  // Advanced configuration
  GPIOEdge _selectedEdge = GPIOEdge.none;
  GPIOBias _selectedBias = GPIOBias.default_;
  GPIODrive _selectedDrive = GPIODrive.default_;
  bool _isInverted = false;

  @override
  void initState() {
    super.initState();
    _pinNumberController = TextEditingController();
    _labelController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add GPIO Pin'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _pinNumberController,
                decoration: const InputDecoration(labelText: 'Pin Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pin number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a label';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Input Pin'),
                value: _isInput,
                onChanged: (value) {
                  setState(() {
                    _isInput = value;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Show Advanced Configuration'),
                value: _showAdvancedConfig,
                onChanged: (value) {
                  setState(() {
                    _showAdvancedConfig = value ?? false;
                  });
                },
              ),
              if (_showAdvancedConfig) ...[
                const Divider(),
                DropdownButtonFormField<GPIOEdge>(
                  decoration:
                      const InputDecoration(labelText: 'Edge Detection'),
                  value: _selectedEdge,
                  items: GPIOEdge.values.map((edge) {
                    return DropdownMenuItem(
                      value: edge,
                      child: Text(edge.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: _isInput
                      ? (GPIOEdge? value) {
                          if (value != null) {
                            setState(() {
                              _selectedEdge = value;
                            });
                          }
                        }
                      : null,
                ),
                DropdownButtonFormField<GPIOBias>(
                  decoration: const InputDecoration(labelText: 'Bias'),
                  value: _selectedBias,
                  items: GPIOBias.values.map((bias) {
                    return DropdownMenuItem(
                      value: bias,
                      child: Text(bias.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (GPIOBias? value) {
                    if (value != null) {
                      setState(() {
                        _selectedBias = value;
                      });
                    }
                  },
                ),
                DropdownButtonFormField<GPIODrive>(
                  decoration: const InputDecoration(labelText: 'Drive'),
                  value: _selectedDrive,
                  items: GPIODrive.values.map((drive) {
                    return DropdownMenuItem(
                      value: drive,
                      child: Text(drive.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: !_isInput
                      ? (GPIODrive? value) {
                          if (value != null) {
                            setState(() {
                              _selectedDrive = value;
                            });
                          }
                        }
                      : null,
                ),
                SwitchListTile(
                  title: const Text('Inverted'),
                  value: _isInverted,
                  onChanged: (value) {
                    setState(() {
                      _isInverted = value;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final config = _showAdvancedConfig
                  ? GPIOConfig(
                      direction:
                          _isInput ? GPIODirection.input : GPIODirection.output,
                      edge: _selectedEdge,
                      bias: _selectedBias,
                      drive: _selectedDrive,
                      inverted: _isInverted,
                      label: _labelController.text,
                    )
                  : null;

              context.read<GPIOCubit>().setupNewPin(
                    pinNumber: int.parse(_pinNumberController.text),
                    isInput: _isInput,
                    label: _labelController.text,
                    config: config,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pinNumberController.dispose();
    _labelController.dispose();
    super.dispose();
  }
}
